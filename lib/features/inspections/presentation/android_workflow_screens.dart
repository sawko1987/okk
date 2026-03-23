import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../core/platform/app_platform.dart';
import '../../../core/utils/user_message.dart';
import '../../../data/sync/sync_service.dart';
import '../../../ui/android_app_bar_actions.dart';
import '../../auth/data/auth_service.dart';
import '../data/inspection_repositories.dart';
import 'android_routes.dart';

class AndroidModeScreen extends ConsumerStatefulWidget {
  const AndroidModeScreen({super.key});

  @override
  ConsumerState<AndroidModeScreen> createState() => _AndroidModeScreenState();
}

class _AndroidModeScreenState extends ConsumerState<AndroidModeScreen> {
  bool _startupSyncTriggered = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_startupSyncTriggered) {
      _startupSyncTriggered = true;
      Future<void>.microtask(
        () => ref.read(syncServiceProvider).syncOnStartup(
              platform: AppPlatform.android,
              actorUserId: session.userId,
            ),
      );
    }

    final canStartInspection =
        roleHasCapability(session.roleCode, AppCapability.startInspection);
    final canViewResults =
        roleHasCapability(session.roleCode, AppCapability.viewResults);
    final canRunSync = roleHasCapability(session.roleCode, AppCapability.runSync);
    final workshopsAsync = ref.watch(inspectionWorkshopsProvider);
    final inspectionDiagnostics = ref.watch(androidInspectionDiagnosticsProvider);
    final syncDiagnostics = ref.watch(syncDiagnosticsProvider);
    final hasWorkshops = workshopsAsync.valueOrNull?.isNotEmpty == true;
    final inspectionFlowEnabled =
        canStartInspection && (workshopsAsync.isLoading || hasWorkshops);
    final inspectionSubtitle = _inspectionFlowSubtitle(
      canStartInspection: canStartInspection,
      workshopsAsync: workshopsAsync,
    );
    final draftSubtitle = canStartInspection
        ? inspectionDiagnostics.when(
            data: (diagnostics) => diagnostics.localDraftCount == 0
                ? 'Продолжите локальные черновики, которые еще можно редактировать.'
                : 'Продолжите локальные черновики (${diagnostics.localDraftCount}), которые еще можно редактировать.',
            loading: () => 'Проверяем локальные черновики...',
            error: (_, _) =>
                'Продолжите локальные черновики, которые еще можно редактировать.',
          )
        : 'Черновики недоступны для этой роли.';
    final resultSubtitle = canViewResults
        ? inspectionDiagnostics.when(
            data: (diagnostics) => diagnostics.conflictCount > 0
                ? 'Просмотрите завершенные результаты и конфликтные случаи (${diagnostics.conflictCount}).'
                : 'Откройте завершенные, ожидающие, синхронизированные или конфликтные результаты.',
            loading: () => 'Загружаем сводку по результатам проверок...',
            error: (_, _) =>
                'Откройте завершенные, ожидающие, синхронизированные или конфликтные результаты.',
          )
        : 'Эта роль не может просматривать результаты проверок.';
    final syncSubtitle = canRunSync
        ? syncDiagnostics.when(
            data: (diagnostics) => diagnostics.transportConfigured
                ? diagnostics.failedQueueCount > 0 || diagnostics.retryEligibleCount > 0
                    ? 'Проверьте проблемы очереди и запустите синхронизацию вручную.'
                    : 'Проверьте состояние очереди и запустите синхронизацию вручную.'
                : 'Настройте доступ к Яндекс.Диску в параметрах перед запуском синхронизации.',
            loading: () => 'Загружаем статус синхронизации...',
            error: (_, _) =>
                'Проверьте состояние очереди и запустите синхронизацию вручную.',
          )
        : 'Синхронизация недоступна для этой роли.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рабочее место Android'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(session.fullName),
              subtitle: Text('Роль: ${session.roleName}'),
            ),
          ),
          const SizedBox(height: 16),
          ...inspectionDiagnostics.when(
            data: (diagnostics) => [
              _StatusCard(
                title: 'Состояние рабочего места',
                lines: [
                  diagnostics.lastReferencePackageId == null
                      ? 'Справочные данные еще не синхронизированы'
                      : 'Пакет справочников: ${diagnostics.lastReferencePackageId}',
                  'Локальные черновики: ${diagnostics.localDraftCount}',
                  'Результаты в очереди: ${diagnostics.queuedResultCount}',
                  'Ошибки очереди: ${diagnostics.failedQueueCount}',
                  'Конфликты: ${diagnostics.conflictCount}',
                  if (diagnostics.lastReferenceSyncAt != null)
                    'Последняя синхронизация справочников: ${diagnostics.lastReferenceSyncAt}',
                  if (diagnostics.lastCompletedInspectionAt != null)
                    'Последняя завершенная проверка: ${diagnostics.lastCompletedInspectionAt}',
                ],
              ),
              const SizedBox(height: 12),
              if (diagnostics.lastReferencePackageId == null || !hasWorkshops)
                const _CalloutCard(
                  icon: Icons.cloud_off_outlined,
                  title: 'Справочные данные не готовы',
                  message:
                      'Запустите синхронизацию перед началом новой проверки. Пока справочные данные недоступны, сценарий проверки заблокирован.',
                ),
              if (diagnostics.hasPendingSyncWork || diagnostics.conflictCount > 0)
                _CalloutCard(
                  icon: diagnostics.conflictCount > 0
                      ? Icons.warning_amber_outlined
                      : Icons.sync_problem_outlined,
                  title: diagnostics.conflictCount > 0
                      ? 'Конфликты требуют проверки администратора'
                      : 'Есть ожидающая синхронизация',
                  message: diagnostics.conflictCount > 0
                      ? 'Среди завершенных проверок есть конфликтные случаи. Перед продолжением откройте результаты или диагностику.'
                      : 'Ожидающие или ошибочные задания синхронизации хранятся локально. Откройте раздел синхронизации, чтобы повторить отправку.',
                ),
            ],
            loading: () => const [
              _StatusCard(
                title: 'Состояние рабочего места',
                lines: ['Загрузка состояния локального рабочего места Android...'],
              ),
              SizedBox(height: 12),
            ],
            error: (error, _) => [
              _CalloutCard(
                icon: Icons.error_outline,
                title: 'Состояние рабочего места недоступно',
                message:
                    'Не удалось загрузить состояние рабочего места. ${userMessageFromError(error, fallback: 'Проверьте локальные данные и повторите попытку.')}',
              ),
              const SizedBox(height: 12),
            ],
          ),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _StatusCard(
                title: 'Состояние синхронизации',
                lines: [
                  'Токен настроен: ${diagnostics.transportConfigured ? 'да' : 'нет'}',
                  'Подключение: ${diagnostics.yandexDiskConnected ? 'да' : 'нет'}',
                  'Доступно для повтора: ${diagnostics.retryEligibleCount}',
                  if (diagnostics.lastSyncAttemptAt != null)
                    'Последняя попытка синхронизации: ${diagnostics.lastSyncAttemptAt}',
                  if (diagnostics.lastError != null)
                    'Последняя ошибка синхронизации: ${diagnostics.lastError}',
                ],
              ),
              const SizedBox(height: 12),
              if (!diagnostics.transportConfigured)
                _ActionCalloutCard(
                  icon: Icons.vpn_key_outlined,
                  title: 'Токен Яндекс.Диска не настроен',
                  message:
                      'Откройте настройки Android и добавьте OAuth-токен перед запуском синхронизации.',
                  actionLabel: 'Открыть настройки',
                  onPressed: () => context.push(AndroidRoutes.settings),
                ),
            ],
            loading: () => const [
              _StatusCard(
                title: 'Состояние синхронизации',
                lines: ['Загрузка диагностики синхронизации...'],
              ),
              SizedBox(height: 12),
            ],
            error: (error, _) => [
              _CalloutCard(
                icon: Icons.error_outline,
                title: 'Состояние синхронизации недоступно',
                message:
                    'Не удалось загрузить диагностику синхронизации. ${userMessageFromError(error, fallback: 'Проверьте настройки и повторите попытку.')}',
              ),
              const SizedBox(height: 12),
            ],
          ),
          Text('Разделы', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.fact_check_outlined,
            title: 'Проведение проверки',
            subtitle: inspectionSubtitle,
            enabled: inspectionFlowEnabled,
            onTap: () => context.push(AndroidRoutes.workshops),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.edit_note_outlined,
            title: 'Черновики проверок',
            subtitle: draftSubtitle,
            enabled: canStartInspection,
            onTap: () => context.push(AndroidRoutes.drafts),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Результаты проверок',
            subtitle: resultSubtitle,
            enabled: canViewResults,
            onTap: () => context.push(AndroidRoutes.results),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.sync_outlined,
            title: 'Синхронизация',
            subtitle: syncSubtitle,
            enabled: canRunSync,
            onTap: () => context.push(AndroidRoutes.sync),
          ),
        ],
      ),
    );
  }
}

class AndroidWorkshopSelectionScreen extends ConsumerWidget {
  const AndroidWorkshopSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canStartInspection =
        roleHasCapability(session.roleCode, AppCapability.startInspection);
    final workshopsAsync = ref.watch(inspectionWorkshopsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор цеха'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: canStartInspection
          ? workshopsAsync.when(
              data: (workshops) {
                if (workshops.isEmpty) {
                  return const Center(
                    child: Text('Синхронизированные цеха с изделиями пока недоступны.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: workshops.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final workshop = workshops[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.factory_outlined),
                        title: Text(workshop.workshopName),
                        subtitle: Text(
                          [
                            if ((workshop.departmentName ?? '').isNotEmpty)
                              workshop.departmentName!,
                            'Изделий: ${workshop.productCount}',
                          ].join(' • '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push(AndroidRoutes.products(workshop.workshopId)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Не удалось загрузить цеха. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
                ),
              ),
            )
          : const Center(
              child: Text('Эта роль не может создавать проверки.'),
            ),
    );
  }
}

class AndroidProductSelectionScreen extends ConsumerWidget {
  const AndroidProductSelectionScreen({
    super.key,
    required this.workshopId,
  });

  final String workshopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final productsAsync = ref.watch(inspectionProductsByWorkshopProvider(workshopId));
    final workshops = ref.watch(inspectionWorkshopsProvider).valueOrNull ?? const [];
    final workshopName = workshops
            .where((workshop) => workshop.workshopId == workshopId)
            .map((workshop) => workshop.workshopName)
            .cast<String?>()
            .firstWhere((value) => value != null, orElse: () => null) ??
        workshopId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Изделия: $workshopName'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('Для этого цеха нет синхронизированных изделий.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(product.productName),
                  subtitle: Text('Участок: ${product.sectionName}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AndroidRoutes.targets(
                      workshopId: workshopId,
                      productId: product.productObjectId,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Не удалось загрузить изделия. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
          ),
        ),
      ),
    );
  }
}

class AndroidTargetSelectionScreen extends ConsumerWidget {
  const AndroidTargetSelectionScreen({
    super.key,
    required this.workshopId,
    required this.productId,
  });

  final String workshopId;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final targetsAsync = ref.watch(inspectionTargetsProvider(productId));
    final products = ref.watch(inspectionProductsByWorkshopProvider(workshopId)).valueOrNull ??
        const [];
    final productName = products
            .where((product) => product.productObjectId == productId)
            .map((product) => product.productName)
            .cast<String?>()
            .firstWhere((value) => value != null, orElse: () => null) ??
        productId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Объекты проверки: $productName'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: targetsAsync.when(
        data: (targets) {
          if (targets.isEmpty) {
            return const Center(
              child: Text('Для этого изделия нет доступных объектов проверки.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: targets.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final target = targets[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.account_tree_outlined),
                  title: Text('${'  ' * target.depth}${target.targetName}'),
                  subtitle: Text('Тип: ${_objectTypeLabel(target.targetType)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AndroidRoutes.components(
                      workshopId: workshopId,
                      productId: productId,
                      targetId: target.targetObjectId,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Не удалось загрузить объекты проверки. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
          ),
        ),
      ),
    );
  }
}

class AndroidComponentsScreen extends ConsumerStatefulWidget {
  const AndroidComponentsScreen({
    super.key,
    required this.workshopId,
    required this.productId,
    required this.targetId,
  });

  final String workshopId;
  final String productId;
  final String targetId;

  @override
  ConsumerState<AndroidComponentsScreen> createState() =>
      _AndroidComponentsScreenState();
}

class _AndroidComponentsScreenState extends ConsumerState<AndroidComponentsScreen> {
  bool _isStarting = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canStartInspection =
        roleHasCapability(session.roleCode, AppCapability.startInspection);
    final targetsAsync = ref.watch(inspectionTargetsProvider(widget.productId));
    final componentsAsync = ref.watch(inspectionComponentsProvider(widget.targetId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Компоненты'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: targetsAsync.when(
        data: (targets) {
          final selectedTarget = targets
              .where((target) => target.targetObjectId == widget.targetId)
              .cast<InspectionTargetOption?>()
              .firstWhere((value) => value != null, orElse: () => null);
          if (selectedTarget == null) {
            return const Center(child: Text('Объект проверки не найден.'));
          }

          return componentsAsync.when(
            data: (components) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedTarget.targetName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Изделие: ${selectedTarget.productName}'),
                        Text('Тип объекта: ${_objectTypeLabel(selectedTarget.targetType)}'),
                        Text('Компонентов: ${components.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Действие с проверкой',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        if (!canStartInspection)
                          const Text(
                            'Эта роль может просматривать данные, но не может создавать или редактировать черновики.',
                          )
                        else
                          FilledButton.icon(
                            onPressed: _isStarting
                                ? null
                                : () => _startDraft(
                                      session: session,
                                      target: selectedTarget,
                                    ),
                            icon: _isStarting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.playlist_add_check_circle_outlined),
                            label: const Text('Открыть черновик'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Список компонентов',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (components.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('Для этого объекта компоненты не назначены.'),
                    ),
                  )
                else
                  for (final component in components) ...[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.precision_manufacturing_outlined),
                        title: Text(component.name),
                        subtitle: Text(
                          [
                            if ((component.code ?? '').isNotEmpty)
                              'Код: ${component.code}',
                            component.isRequired ? 'Обязательный' : 'Необязательный',
                            'Изображений: ${component.imagePaths.length}',
                          ].join(' • '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          AndroidRoutes.component(
                            workshopId: widget.workshopId,
                            productId: widget.productId,
                            targetId: widget.targetId,
                            componentId: component.componentId,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'Не удалось загрузить компоненты. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Не удалось загрузить объект проверки. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
          ),
        ),
      ),
    );
  }

  Future<void> _startDraft({
    required AuthSession session,
    required InspectionTargetOption target,
  }) async {
    setState(() => _isStarting = true);
    try {
      final detail = await ref.read(syncServiceProvider).startInspectionDraft(
            request: InspectionStartRequest(
              userId: session.userId,
              productObjectId: widget.productId,
              targetObjectId: target.targetObjectId,
            ),
          );
      ref.invalidate(androidInspectionDiagnosticsProvider);
      ref.invalidate(syncDiagnosticsProvider);
      ref.invalidate(inspectionDraftsProvider(session.userId));
      ref.invalidate(inspectionResultsProvider(session.userId));
      if (!mounted) {
        return;
      }
      await context.push(AndroidRoutes.inspection(detail.inspection.id));
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userMessageFromText(
              error.message.toString(),
              fallback: 'Не удалось открыть черновик проверки.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }
}

class AndroidComponentDetailsScreen extends ConsumerWidget {
  const AndroidComponentDetailsScreen({
    super.key,
    required this.componentId,
  });

  final String componentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final componentAsync = ref.watch(inspectionComponentProvider(componentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточка компонента'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: componentAsync.when(
        data: (component) {
          if (component == null) {
            return const Center(child: Text('Компонент не найден.'));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if ((component.code ?? '').isNotEmpty)
                        Text('Код: ${component.code}'),
                      Text(
                        component.isRequired
                            ? 'Обязательный компонент'
                            : 'Необязательный компонент',
                      ),
                      if ((component.description ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(component.description!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Локальные изображения',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (component.imagePaths.isEmpty)
                const Card(
                  child: ListTile(
                    title: Text('Для этого компонента нет локальных изображений.'),
                  ),
                )
              else
                for (final imagePath in component.imagePaths) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(imagePath),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                    height: 180,
                                    child: Center(
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Не удалось загрузить компонент. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
          ),
        ),
      ),
    );
  }
}

class AndroidDraftsScreen extends ConsumerWidget {
  const AndroidDraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canStartInspection =
        roleHasCapability(session.roleCode, AppCapability.startInspection);
    final draftsAsync = ref.watch(inspectionDraftsProvider(session.userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Черновики проверок'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: canStartInspection
          ? draftsAsync.when(
              data: (drafts) {
                if (drafts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _ActionCalloutCard(
                        icon: Icons.edit_note_outlined,
                        title: 'Черновиков проверок пока нет',
                        message:
                            'Начните новую проверку из рабочего места, чтобы создать первый черновик на этом устройстве.',
                        actionLabel: 'Открыть сценарий проверки',
                        onPressed: () => context.go(AndroidRoutes.workshops),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: drafts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final draft = drafts[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.edit_note_outlined),
                        title: Text(draft.targetName),
                        subtitle: Text(
                          '${draft.productName} | ${draft.answeredItems}/${draft.totalItems} отвечено | ${draft.updatedAt}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push(AndroidRoutes.inspection(draft.inspectionId)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Не удалось загрузить черновики. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
                ),
              ),
            )
          : const Center(
              child: Text('Эта роль не может создавать или редактировать черновики проверок.'),
            ),
    );
  }
}

class AndroidResultsScreen extends ConsumerWidget {
  const AndroidResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canViewResults =
        roleHasCapability(session.roleCode, AppCapability.viewResults);
    final resultsAsync = ref.watch(inspectionResultsProvider(session.userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты проверок'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: canViewResults
          ? resultsAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _ActionCalloutCard(
                        icon: Icons.assignment_turned_in_outlined,
                        title: 'Завершенных проверок пока нет',
                        message:
                            'Завершенные проверки появятся здесь после локального завершения, после чего их можно будет просмотреть или синхронизировать.',
                        actionLabel: 'Открыть рабочее место',
                        onPressed: () => context.go(AndroidRoutes.home),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.assignment_turned_in_outlined),
                        title: Text(result.targetName),
                        subtitle: Text(
                          '${result.productName} | ${_inspectionStatusLabel(result.status)} / ${_syncStatusLabel(result.syncStatus)} | подписей: ${result.signatureCount} | PDF: ${result.hasPdf ? 'да' : 'нет'}',
                        ),
                        trailing: Text(result.completedAt),
                        onTap: () =>
                            context.push(AndroidRoutes.inspection(result.inspectionId)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Не удалось загрузить результаты. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
                ),
              ),
            )
          : const Center(
              child: Text('Эта роль не может просматривать результаты проверок.'),
            ),
    );
  }
}

class AndroidSyncScreen extends ConsumerStatefulWidget {
  const AndroidSyncScreen({super.key});

  @override
  ConsumerState<AndroidSyncScreen> createState() => _AndroidSyncScreenState();
}

class _AndroidSyncScreenState extends ConsumerState<AndroidSyncScreen> {
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider).valueOrNull;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canRunSync = roleHasCapability(session.roleCode, AppCapability.runSync);
    final inspectionDiagnostics = ref.watch(androidInspectionDiagnosticsProvider);
    final syncDiagnostics = ref.watch(syncDiagnosticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Синхронизация'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Действия синхронизации',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (!canRunSync)
                    const Text('Эта роль не может запускать синхронизацию.')
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: _isSyncing ? null : () => _runSync(session),
                          icon: _isSyncing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.sync),
                          label: const Text('Синхронизировать'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push(AndroidRoutes.settings),
                          icon: const Icon(Icons.settings_outlined),
                          label: const Text('Настройки'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push(AndroidRoutes.diagnostics),
                          icon: const Icon(Icons.monitor_heart_outlined),
                          label: const Text('Диагностика'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...inspectionDiagnostics.when(
            data: (diagnostics) => [
              _InfoCard(
                title: 'Рабочее место проверки',
                lines: [
                  'Локальные черновики: ${diagnostics.localDraftCount}',
                  'Результаты в очереди: ${diagnostics.queuedResultCount}',
                  'Ошибки очереди: ${diagnostics.failedQueueCount}',
                  'Конфликты: ${diagnostics.conflictCount}',
                  'Последний пакет справочников: ${diagnostics.lastReferencePackageId ?? 'н/д'}',
                  'Последняя синхронизация справочников: ${diagnostics.lastReferenceSyncAt ?? 'н/д'}',
                  'Последняя попытка синхронизации: ${diagnostics.lastSyncAttemptAt ?? 'н/д'}',
                  'Последняя завершенная проверка: ${diagnostics.lastCompletedInspectionAt ?? 'н/д'}',
                ],
              ),
              if (diagnostics.lastReferencePackageId == null)
                _ActionCalloutCard(
                  icon: Icons.cloud_download_outlined,
                  title: 'Справочные данные еще не синхронизированы',
                  message:
                      'Запустите синхронизацию после того, как администратор Windows опубликует пакет справочников.',
                  actionLabel: 'Обновить рабочее место',
                  onPressed: () => context.go(AndroidRoutes.home),
                ),
              if (diagnostics.hasPendingSyncWork)
                const _CalloutCard(
                  icon: Icons.schedule_outlined,
                  title: 'Есть ожидающая локальная синхронизация',
                  message:
                      'Ожидающие или ошибочные пакеты результатов остаются на устройстве, пока синхронизация не завершится успешно.',
                ),
            ],
            loading: () => const [
              _InfoCard(title: 'Рабочее место проверки', lines: ['Загрузка...']),
            ],
            error: (error, _) => [
              _InfoCard(
                title: 'Рабочее место проверки',
                lines: [
                  userMessageFromError(
                    error,
                    fallback: 'Не удалось загрузить данные рабочего места.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _InfoCard(
                title: 'Диагностика транспорта',
                lines: _syncLines(diagnostics),
              ),
              if (!diagnostics.transportConfigured)
                _ActionCalloutCard(
                  icon: Icons.vpn_key_outlined,
                  title: 'Токен Яндекс.Диска отсутствует',
                  message:
                      'Откройте настройки Android и сохраните OAuth-токен перед запуском синхронизации.',
                  actionLabel: 'Открыть настройки',
                  onPressed: () => context.push(AndroidRoutes.settings),
                ),
            ],
            loading: () => const [
              _InfoCard(title: 'Диагностика транспорта', lines: ['Загрузка...']),
            ],
            error: (error, _) => [
              _InfoCard(
                title: 'Диагностика транспорта',
                lines: [
                  userMessageFromError(
                    error,
                    fallback: 'Не удалось загрузить диагностику транспорта.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _runSync(AuthSession session) async {
    setState(() => _isSyncing = true);
    try {
      final report = await ref.read(syncServiceProvider).runManualSync(
            platform: AppPlatform.android,
            actorUserId: session.userId,
          );
      ref.invalidate(androidInspectionDiagnosticsProvider);
      ref.invalidate(syncDiagnosticsProvider);
      ref.invalidate(inspectionWorkshopsProvider);
      ref.invalidate(inspectionDraftsProvider(session.userId));
      ref.invalidate(inspectionResultsProvider(session.userId));
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(report.summaryLabel())),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userMessageFromError(
              error,
              fallback: 'Не удалось выполнить синхронизацию.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }
}

List<String> _syncLines(SyncDiagnosticsSnapshot diagnostics) {
  return [
    'ID устройства: ${diagnostics.deviceId ?? 'н/д'}',
    'Последняя отправка результата: ${diagnostics.lastResultPushAt ?? 'н/д'}',
    'Последнее получение результата: ${diagnostics.lastResultPullAt ?? 'н/д'}',
    'Последний успех: ${diagnostics.lastSuccessAt ?? 'н/д'}',
    'Последняя попытка: ${diagnostics.lastSyncAttemptAt ?? 'н/д'}',
    'Последний повтор: ${diagnostics.lastRetryAt ?? 'н/д'}',
    'Последний конфликт: ${diagnostics.lastConflictAt ?? 'н/д'}',
    'Последняя ошибка: ${diagnostics.lastError ?? 'н/д'}',
    'Ожидает отправки: ${diagnostics.pendingOutgoingCount}',
    'Ожидает получения: ${diagnostics.pendingIncomingCount}',
    'Ошибки очереди: ${diagnostics.failedQueueCount}',
    'Доступно для повтора: ${diagnostics.retryEligibleCount}',
    'Количество конфликтов: ${diagnostics.conflictCount}',
    'Токен настроен: ${diagnostics.transportConfigured ? 'да' : 'нет'}',
    'Подключение: ${diagnostics.yandexDiskConnected ? 'да' : 'нет'}',
  ];
}

String _inspectionStatusLabel(String status) {
  return switch (status) {
    'draft' => 'Черновик',
    'in_progress' => 'В работе',
    'queued' => 'В очереди',
    'completed' => 'Завершена',
    'synced' => 'Синхронизирована',
    'conflict' => 'Конфликт',
    _ => status,
  };
}

String _syncStatusLabel(String status) {
  return switch (status) {
    'local_only' => 'Локально',
    'queued' => 'В очереди',
    'pending' => 'Ожидает обработки',
    'synced' => 'Синхронизировано',
    'failed' => 'Ошибка',
    'conflict' => 'Конфликт',
    _ => status,
  };
}

String _objectTypeLabel(String type) {
  return switch (type) {
    'product' => 'Изделие',
    'machine' => 'Машина',
    'place' => 'Место',
    'node' => 'Узел',
    'detail' => 'Деталь',
    _ => type,
  };
}

String _inspectionFlowSubtitle({
  required bool canStartInspection,
  required AsyncValue<List<InspectionWorkshopOption>> workshopsAsync,
}) {
  if (!canStartInspection) {
    return 'Эта роль не может создавать или редактировать проверки.';
  }
  return workshopsAsync.when(
    data: (workshops) => workshops.isEmpty
        ? 'Синхронизированные цеха с изделиями пока недоступны. Сначала выполните синхронизацию.'
        : 'Выберите цех, изделие и объект проверки, изучите компоненты и откройте черновик.',
    loading: () => 'Проверяем синхронизированные цеха и изделия...',
    error: (error, _) =>
        'Не удалось загрузить синхронизированные цеха. Перед началом новой проверки проверьте диагностику.',
  );
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        enabled: enabled,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right,
          color: enabled ? null : Theme.of(context).disabledColor,
        ),
        onTap: enabled ? onTap : null,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final line in lines) ...[
              Text(line),
              const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final line in lines) ...[
              Text(line),
              const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  const _CalloutCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(message),
      ),
    );
  }
}

class _ActionCalloutCard extends StatelessWidget {
  const _ActionCalloutCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(message),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: onPressed,
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
