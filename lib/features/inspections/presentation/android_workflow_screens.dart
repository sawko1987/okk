import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_permissions.dart';
import '../../../core/platform/app_platform.dart';
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
                ? 'Resume local drafts that are still editable.'
                : 'Resume ${diagnostics.localDraftCount} local drafts that are still editable.',
            loading: () => 'Checking local drafts...',
            error: (_, _) => 'Resume local drafts that are still editable.',
          )
        : 'Drafts are unavailable for this role.';
    final resultSubtitle = canViewResults
        ? inspectionDiagnostics.when(
            data: (diagnostics) => diagnostics.conflictCount > 0
                ? 'Review completed results and ${diagnostics.conflictCount} conflict case(s).'
                : 'Open completed, queued, synced, or conflict results.',
            loading: () => 'Loading inspection result summary...',
            error: (_, _) => 'Open completed, queued, synced, or conflict results.',
          )
        : 'This role cannot review inspection results.';
    final syncSubtitle = canRunSync
        ? syncDiagnostics.when(
            data: (diagnostics) => diagnostics.transportConfigured
                ? diagnostics.failedQueueCount > 0 || diagnostics.retryEligibleCount > 0
                    ? 'Review queue issues and run manual synchronization.'
                    : 'Review queue state and run manual sync.'
                : 'Configure Yandex Disk access in settings before running sync.',
            loading: () => 'Loading sync status...',
            error: (_, _) => 'Review queue state and run manual sync.',
          )
        : 'Sync is unavailable for this role.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Android workspace'),
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
              subtitle: Text('Role: ${session.roleName}'),
            ),
          ),
          const SizedBox(height: 16),
          ...inspectionDiagnostics.when(
            data: (diagnostics) => [
              _StatusCard(
                title: 'Workspace status',
                lines: [
                  diagnostics.lastReferencePackageId == null
                      ? 'Reference data: not synced yet'
                      : 'Reference package: ${diagnostics.lastReferencePackageId}',
                  'Local drafts: ${diagnostics.localDraftCount}',
                  'Queued results: ${diagnostics.queuedResultCount}',
                  'Failed queue entries: ${diagnostics.failedQueueCount}',
                  'Conflicts: ${diagnostics.conflictCount}',
                  if (diagnostics.lastReferenceSyncAt != null)
                    'Last reference sync: ${diagnostics.lastReferenceSyncAt}',
                  if (diagnostics.lastCompletedInspectionAt != null)
                    'Last completed inspection: ${diagnostics.lastCompletedInspectionAt}',
                ],
              ),
              const SizedBox(height: 12),
              if (diagnostics.lastReferencePackageId == null || !hasWorkshops)
                const _CalloutCard(
                  icon: Icons.cloud_off_outlined,
                  title: 'Reference data is not ready',
                  message:
                      'Run synchronization before starting a new inspection. Until reference data is available, the inspection flow stays unavailable.',
                ),
              if (diagnostics.hasPendingSyncWork || diagnostics.conflictCount > 0)
                _CalloutCard(
                  icon: diagnostics.conflictCount > 0
                      ? Icons.warning_amber_outlined
                      : Icons.sync_problem_outlined,
                  title: diagnostics.conflictCount > 0
                      ? 'Conflicts need administrator review'
                      : 'Pending sync work is waiting',
                  message: diagnostics.conflictCount > 0
                      ? 'Completed inspections include conflict cases. Open results or diagnostics before continuing.'
                      : 'Queued or failed sync work is stored locally. Open synchronization to retry when ready.',
                ),
            ],
            loading: () => const [
              _StatusCard(
                title: 'Workspace status',
                lines: ['Loading local Android workspace status...'],
              ),
              SizedBox(height: 12),
            ],
            error: (error, _) => [
              _CalloutCard(
                icon: Icons.error_outline,
                title: 'Workspace status unavailable',
                message: 'Failed to load Android workspace status: $error',
              ),
              const SizedBox(height: 12),
            ],
          ),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _StatusCard(
                title: 'Sync status',
                lines: [
                  'Token configured: ${diagnostics.transportConfigured ? 'yes' : 'no'}',
                  'Connected: ${diagnostics.yandexDiskConnected ? 'yes' : 'no'}',
                  'Retry-eligible queue: ${diagnostics.retryEligibleCount}',
                  if (diagnostics.lastSyncAttemptAt != null)
                    'Last sync attempt: ${diagnostics.lastSyncAttemptAt}',
                  if (diagnostics.lastError != null)
                    'Last sync error: ${diagnostics.lastError}',
                ],
              ),
              const SizedBox(height: 12),
              if (!diagnostics.transportConfigured)
                _ActionCalloutCard(
                  icon: Icons.vpn_key_outlined,
                  title: 'Yandex Disk token is not configured',
                  message:
                      'Open Android settings and add the OAuth token before running synchronization.',
                  actionLabel: 'Open settings',
                  onPressed: () => context.push(AndroidRoutes.settings),
                ),
            ],
            loading: () => const [
              _StatusCard(
                title: 'Sync status',
                lines: ['Loading synchronization diagnostics...'],
              ),
              SizedBox(height: 12),
            ],
            error: (error, _) => [
              _CalloutCard(
                icon: Icons.error_outline,
                title: 'Sync status unavailable',
                message: 'Failed to load sync diagnostics: $error',
              ),
              const SizedBox(height: 12),
            ],
          ),
          Text('Modes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.fact_check_outlined,
            title: 'Inspection flow',
            subtitle: inspectionSubtitle,
            enabled: inspectionFlowEnabled,
            onTap: () => context.push(AndroidRoutes.workshops),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.edit_note_outlined,
            title: 'Draft inspections',
            subtitle: draftSubtitle,
            enabled: canStartInspection,
            onTap: () => context.push(AndroidRoutes.drafts),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Inspection results',
            subtitle: resultSubtitle,
            enabled: canViewResults,
            onTap: () => context.push(AndroidRoutes.results),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.sync_outlined,
            title: 'Synchronization',
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
        title: const Text('Select workshop'),
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
                    child: Text('No synced workshops with products are available yet.'),
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
                            '${workshop.productCount} products',
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
              error: (error, _) =>
                  Center(child: Text('Failed to load workshops: $error')),
            )
          : const Center(
              child: Text('This role cannot create inspections.'),
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
        title: Text('Products: $workshopName'),
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
              child: Text('No synced products are available for this workshop.'),
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
                  subtitle: Text('Section: ${product.sectionName}'),
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
        error: (error, _) => Center(child: Text('Failed to load products: $error')),
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
        title: Text('Targets: $productName'),
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
              child: Text('No inspection targets are available for this product.'),
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
                  subtitle: Text('Type: ${target.targetType}'),
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
        error: (error, _) => Center(child: Text('Failed to load targets: $error')),
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
        title: const Text('Components'),
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
            return const Center(child: Text('Inspection target not found.'));
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
                        Text('Product: ${selectedTarget.productName}'),
                        Text('Target type: ${selectedTarget.targetType}'),
                        Text('Components: ${components.length}'),
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
                          'Inspection action',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        if (!canStartInspection)
                          const Text(
                            'This role can review data but cannot create or edit drafts.',
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
                            label: const Text('Open draft'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Component list',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (components.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('No components are assigned to this object.'),
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
                              'Code: ${component.code}',
                            component.isRequired ? 'Required' : 'Optional',
                            '${component.imagePaths.length} images',
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
            error: (error, _) =>
                Center(child: Text('Failed to load components: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load target: $error')),
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
        SnackBar(content: Text(error.message.toString())),
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
        title: const Text('Component card'),
        actions: buildAndroidAppBarActions(
          context: context,
          ref: ref,
          session: session,
        ),
      ),
      body: componentAsync.when(
        data: (component) {
          if (component == null) {
            return const Center(child: Text('Component not found.'));
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
                        Text('Code: ${component.code}'),
                      Text(component.isRequired ? 'Required component' : 'Optional component'),
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
                'Local images',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (component.imagePaths.isEmpty)
                const Card(
                  child: ListTile(
                    title: Text('No local images are available for this component.'),
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
        error: (error, _) => Center(child: Text('Failed to load component: $error')),
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
        title: const Text('Draft inspections'),
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
                        title: 'No draft inspections yet',
                        message:
                            'Start a new inspection from the workspace flow to create the first draft on this device.',
                        actionLabel: 'Open inspection flow',
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
                          '${draft.productName} • ${draft.answeredItems}/${draft.totalItems} answered • ${draft.updatedAt}',
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
              error: (error, _) =>
                  Center(child: Text('Failed to load drafts: $error')),
            )
          : const Center(
              child: Text('This role cannot create or edit draft inspections.'),
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
        title: const Text('Inspection results'),
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
                        title: 'No completed inspections yet',
                        message:
                            'Completed inspections will appear here after local completion and can then be reviewed or synchronized.',
                        actionLabel: 'Open workspace',
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
                          '${result.productName} • ${result.status}/${result.syncStatus} • signatures: ${result.signatureCount} • pdf: ${result.hasPdf ? 'yes' : 'no'}',
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
              error: (error, _) =>
                  Center(child: Text('Failed to load results: $error')),
            )
          : const Center(
              child: Text('This role cannot review inspection results.'),
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
        title: const Text('Synchronization'),
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
                    'Sync actions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (!canRunSync)
                    const Text('This role cannot run synchronization.')
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
                          label: const Text('Sync now'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push(AndroidRoutes.settings),
                          icon: const Icon(Icons.settings_outlined),
                          label: const Text('Settings'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.push(AndroidRoutes.diagnostics),
                          icon: const Icon(Icons.monitor_heart_outlined),
                          label: const Text('Diagnostics'),
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
                title: 'Inspection workspace',
                lines: [
                  'Local drafts: ${diagnostics.localDraftCount}',
                  'Queued results: ${diagnostics.queuedResultCount}',
                  'Failed queue entries: ${diagnostics.failedQueueCount}',
                  'Conflicts: ${diagnostics.conflictCount}',
                  'Last reference package: ${diagnostics.lastReferencePackageId ?? 'n/a'}',
                  'Last reference sync: ${diagnostics.lastReferenceSyncAt ?? 'n/a'}',
                  'Last sync attempt: ${diagnostics.lastSyncAttemptAt ?? 'n/a'}',
                  'Last completed inspection: ${diagnostics.lastCompletedInspectionAt ?? 'n/a'}',
                ],
              ),
              if (diagnostics.lastReferencePackageId == null)
                _ActionCalloutCard(
                  icon: Icons.cloud_download_outlined,
                  title: 'Reference data has not been synchronized yet',
                  message:
                      'Run synchronization after the Windows administrator publishes a reference package.',
                  actionLabel: 'Refresh workspace',
                  onPressed: () => context.go(AndroidRoutes.home),
                ),
              if (diagnostics.hasPendingSyncWork)
                const _CalloutCard(
                  icon: Icons.schedule_outlined,
                  title: 'Pending local sync work',
                  message:
                      'Queued or failed result packages are still stored on this device until synchronization completes successfully.',
                ),
            ],
            loading: () => const [
              _InfoCard(title: 'Inspection workspace', lines: ['loading...']),
            ],
            error: (error, _) => [
              _InfoCard(
                title: 'Inspection workspace',
                lines: ['error: $error'],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...syncDiagnostics.when(
            data: (diagnostics) => [
              _InfoCard(
                title: 'Transport diagnostics',
                lines: _syncLines(diagnostics),
              ),
              if (!diagnostics.transportConfigured)
                _ActionCalloutCard(
                  icon: Icons.vpn_key_outlined,
                  title: 'Yandex Disk token is missing',
                  message:
                      'Open Android settings and store the OAuth token before running synchronization.',
                  actionLabel: 'Open settings',
                  onPressed: () => context.push(AndroidRoutes.settings),
                ),
            ],
            loading: () => const [
              _InfoCard(title: 'Transport diagnostics', lines: ['loading...']),
            ],
            error: (error, _) => [
              _InfoCard(
                title: 'Transport diagnostics',
                lines: ['error: $error'],
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
        SnackBar(content: Text(error.toString())),
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
    'Device id: ${diagnostics.deviceId ?? 'n/a'}',
    'Last result push: ${diagnostics.lastResultPushAt ?? 'n/a'}',
    'Last result pull: ${diagnostics.lastResultPullAt ?? 'n/a'}',
    'Last success: ${diagnostics.lastSuccessAt ?? 'n/a'}',
    'Last attempt: ${diagnostics.lastSyncAttemptAt ?? 'n/a'}',
    'Last retry run: ${diagnostics.lastRetryAt ?? 'n/a'}',
    'Last conflict: ${diagnostics.lastConflictAt ?? 'n/a'}',
    'Last error: ${diagnostics.lastError ?? 'n/a'}',
    'Pending outgoing: ${diagnostics.pendingOutgoingCount}',
    'Pending incoming: ${diagnostics.pendingIncomingCount}',
    'Failed queue entries: ${diagnostics.failedQueueCount}',
    'Retry-eligible queue entries: ${diagnostics.retryEligibleCount}',
    'Conflict count: ${diagnostics.conflictCount}',
    'Token configured: ${diagnostics.transportConfigured ? 'yes' : 'no'}',
    'Connected: ${diagnostics.yandexDiskConnected ? 'yes' : 'no'}',
  ];
}

String _inspectionFlowSubtitle({
  required bool canStartInspection,
  required AsyncValue<List<InspectionWorkshopOption>> workshopsAsync,
}) {
  if (!canStartInspection) {
    return 'This role cannot create or edit inspections.';
  }
  return workshopsAsync.when(
    data: (workshops) => workshops.isEmpty
        ? 'No synced workshops with products are available yet. Run synchronization first.'
        : 'Select workshop, product, target, review components, and open a draft.',
    loading: () => 'Checking synced workshops and products...',
    error: (error, _) =>
        'Failed to load synced workshops. Review diagnostics before starting a new inspection.',
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
