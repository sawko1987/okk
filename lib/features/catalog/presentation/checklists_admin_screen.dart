import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/user_message.dart';
import '../../auth/data/auth_service.dart';
import '../data/master_data_repositories.dart';

final _selectedChecklistIdProvider = StateProvider<String?>((ref) => null);

class ChecklistsAdminScreen extends ConsumerWidget {
  const ChecklistsAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistsAsync = ref.watch(checklistsProvider);
    final canEdit = ref.watch(isAdministratorProvider);

    return checklistsAsync.when(
      data: (checklists) {
        final selectedChecklistId =
            ref.watch(_selectedChecklistIdProvider) ??
            (checklists.isNotEmpty ? checklists.first.id : null);
        final detailAsync = selectedChecklistId == null
            ? null
            : ref.watch(checklistDetailProvider(selectedChecklistId));

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!canEdit)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Редактирование доступно только администратору.',
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Чек-листы',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: canEdit
                                  ? () => _editChecklist(context, ref)
                                  : null,
                              icon: const Icon(Icons.add),
                              label: const Text('Создать'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (checklists.isEmpty)
                          const Expanded(
                            child: Center(child: Text('Чек-листов пока нет.')),
                          )
                        else
                          Expanded(
                            child: ListView(
                              children: [
                                for (final checklist in checklists)
                                  Card(
                                    child: ListTile(
                                      title: Text(checklist.name),
                                      subtitle: Text(
                                        checklist.isActive
                                            ? 'Активен'
                                            : 'Неактивен',
                                      ),
                                      selected:
                                          checklist.id == selectedChecklistId,
                                      onTap: () =>
                                          ref
                                                  .read(
                                                    _selectedChecklistIdProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              checklist.id,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: selectedChecklistId == null
                        ? const Text('Создайте первый чек-лист.')
                        : detailAsync!.when(
                            data: (detail) {
                              if (detail == null) {
                                return const Text('Чек-лист не найден.');
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            detail.checklist.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: canEdit
                                              ? () => _editChecklist(
                                                  context,
                                                  ref,
                                                  checklist: detail.checklist,
                                                )
                                              : null,
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          onPressed: canEdit
                                              ? () => _deleteChecklist(
                                                  ref,
                                                  detail.checklist.id,
                                                )
                                              : null,
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      detail.checklist.description ??
                                          'Без описания',
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Пункты',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    if (detail.items.isEmpty)
                                      const Text(
                                        'В этом чек-листе нет пунктов.',
                                      )
                                    else
                                      ...detail.items.map(
                                        (item) => Card(
                                          child: ListTile(
                                            title: Text(item.title),
                                            subtitle: Text(
                                              '${item.resultType} | ${item.isRequired ? 'обязательный' : 'необязательный'}',
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Привязки',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    if (detail.bindings.isEmpty)
                                      const Text(
                                        'Для этого чек-листа нет привязок.',
                                      )
                                    else
                                      ...detail.bindings.map(
                                        (binding) => Card(
                                          child: ListTile(
                                            title: Text(binding.targetType),
                                            subtitle: Text(
                                              'приоритет ${binding.priority} | ${binding.targetId ?? binding.targetObjectType ?? '-'}',
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, _) => Text(
                              'Не удалось загрузить редактор чек-листа. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Не удалось загрузить чек-листы. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
        ),
      ),
    );
  }

  Future<void> _editChecklist(
    BuildContext context,
    WidgetRef ref, {
    Checklist? checklist,
  }) async {
    final nameController = TextEditingController(text: checklist?.name ?? '');
    final descriptionController = TextEditingController(
      text: checklist?.description ?? '',
    );
    var isActive = checklist?.isActive ?? true;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            checklist == null ? 'Новый чек-лист' : 'Редактирование чек-листа',
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Активен'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
    if (shouldSave != true) {
      return;
    }

    final id = await ref
        .read(checklistsRepositoryProvider)
        .saveChecklist(
          id: checklist?.id,
          name: nameController.text,
          description: descriptionController.text,
          isActive: isActive,
          actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
        );
    ref.read(_selectedChecklistIdProvider.notifier).state = id;
    ref.invalidate(checklistsProvider);
    ref.invalidate(checklistDetailProvider(id));
  }

  Future<void> _deleteChecklist(WidgetRef ref, String checklistId) async {
    await ref
        .read(checklistsRepositoryProvider)
        .deleteChecklist(
          checklistId,
          actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
        );
    ref.read(_selectedChecklistIdProvider.notifier).state = null;
    ref.invalidate(checklistsProvider);
    ref.invalidate(checklistDetailProvider(checklistId));
  }
}
