import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/master_data_repositories.dart';

final _selectedChecklistIdProvider = StateProvider<String?>((ref) => null);

class ChecklistsAdminScreen extends ConsumerWidget {
  const ChecklistsAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistsAsync = ref.watch(checklistsProvider);
    final referenceDataAsync = ref.watch(checklistReferenceDataProvider);

    return checklistsAsync.when(
      data: (checklists) {
        final selectedChecklistId = ref.watch(_selectedChecklistIdProvider) ??
            (checklists.isNotEmpty ? checklists.first.id : null);

        return referenceDataAsync.when(
          data: (referenceData) {
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Чек-листы',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                FilledButton.icon(
                                  onPressed: () => _editChecklist(context, ref),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Создать'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (checklists.isEmpty)
                              const Text('Чек-листов пока нет.')
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
                                          onTap: () => ref
                                              .read(_selectedChecklistIdProvider.notifier)
                                              .state = checklist.id,
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => _editChecklist(
                                                context,
                                                ref,
                                                checklist: detail.checklist,
                                              ),
                                              icon: const Icon(Icons.edit_outlined),
                                            ),
                                            IconButton(
                                              onPressed: () => _deleteChecklist(
                                                context,
                                                ref,
                                                detail.checklist.id,
                                              ),
                                              icon: const Icon(Icons.delete_outline),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          detail.checklist.description ?? 'Без описания',
                                        ),
                                        const SizedBox(height: 24),
                                        _ChecklistSectionHeader(
                                          title: 'Пункты',
                                          actionLabel: 'Добавить пункт',
                                          onAction: () => _editChecklistItem(
                                            context,
                                            ref,
                                            checklistId: detail.checklist.id,
                                            referenceData: referenceData,
                                          ),
                                        ),
                                        if (detail.items.isEmpty)
                                          const Text('Пунктов пока нет.')
                                        else
                                          ...detail.items.map(
                                            (item) => Card(
                                              child: ListTile(
                                                title: Text(item.title),
                                                subtitle: Text(
                                                  '${item.resultType} • '
                                                  '${item.isRequired ? 'обязательный' : 'необязательный'}',
                                                ),
                                                trailing: Wrap(
                                                  spacing: 8,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () => _editChecklistItem(
                                                        context,
                                                        ref,
                                                        checklistId:
                                                            detail.checklist.id,
                                                        referenceData:
                                                            referenceData,
                                                        item: item,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          _deleteChecklistItem(
                                                        context,
                                                        ref,
                                                        checklistId:
                                                            detail.checklist.id,
                                                        itemId: item.id,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 24),
                                        _ChecklistSectionHeader(
                                          title: 'Привязки',
                                          actionLabel: 'Добавить привязку',
                                          onAction: () => _editChecklistBinding(
                                            context,
                                            ref,
                                            checklistId: detail.checklist.id,
                                            referenceData: referenceData,
                                          ),
                                        ),
                                        if (detail.bindings.isEmpty)
                                          const Text('Привязок пока нет.')
                                        else
                                          ...detail.bindings.map(
                                            (binding) => Card(
                                              child: ListTile(
                                                title: Text(
                                                  _bindingTitle(
                                                    binding,
                                                    referenceData,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'priority: ${binding.priority} • '
                                                  '${binding.isRequired ? 'обязательная' : 'необязательная'}',
                                                ),
                                                trailing: Wrap(
                                                  spacing: 8,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () => _editChecklistBinding(
                                                        context,
                                                        ref,
                                                        checklistId:
                                                            detail.checklist.id,
                                                        referenceData:
                                                            referenceData,
                                                        binding: binding,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          _deleteChecklistBinding(
                                                        context,
                                                        ref,
                                                        checklistId:
                                                            detail.checklist.id,
                                                        bindingId: binding.id,
                                                      ),
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                loading: () =>
                                    const Center(child: CircularProgressIndicator()),
                                error: (error, _) => Text(
                                  'Ошибка загрузки редактора чек-листа: $error',
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
          error: (error, _) =>
              Center(child: Text('Ошибка загрузки справочников: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Ошибка загрузки чек-листов: $error')),
    );
  }

  Future<void> _editChecklist(
    BuildContext context,
    WidgetRef ref, {
    Checklist? checklist,
  }) async {
    final result = await showDialog<_ChecklistFormResult>(
      context: context,
      builder: (context) => _ChecklistEditorDialog(checklist: checklist),
    );
    if (result == null) {
      return;
    }

    final id = await ref.read(checklistsRepositoryProvider).saveChecklist(
          id: checklist?.id,
          name: result.name,
          description: result.description,
          isActive: result.isActive,
        );
    ref.read(_selectedChecklistIdProvider.notifier).state = id;
    _invalidateChecklistState(ref, id);
  }

  Future<void> _deleteChecklist(
    BuildContext context,
    WidgetRef ref,
    String checklistId,
  ) async {
    await ref.read(checklistsRepositoryProvider).deleteChecklist(checklistId);
    ref.read(_selectedChecklistIdProvider.notifier).state = null;
    _invalidateChecklistState(ref, checklistId);
  }

  Future<void> _editChecklistItem(
    BuildContext context,
    WidgetRef ref, {
    required String checklistId,
    required ChecklistReferenceData referenceData,
    ChecklistItem? item,
  }) async {
    final result = await showDialog<_ChecklistItemFormResult>(
      context: context,
      builder: (context) => _ChecklistItemDialog(
        referenceData: referenceData,
        item: item,
      ),
    );
    if (result == null) {
      return;
    }

    await ref.read(checklistsRepositoryProvider).saveChecklistItem(
          id: item?.id,
          checklistId: checklistId,
          componentId: result.componentId,
          title: result.title,
          description: result.description,
          expectedResult: result.expectedResult,
          resultType: result.resultType,
          isRequired: result.isRequired,
          sortOrder: result.sortOrder,
        );
    _invalidateChecklistState(ref, checklistId);
  }

  Future<void> _deleteChecklistItem(
    BuildContext context,
    WidgetRef ref, {
    required String checklistId,
    required String itemId,
  }) async {
    await ref.read(checklistsRepositoryProvider).deleteChecklistItem(itemId);
    _invalidateChecklistState(ref, checklistId);
  }

  Future<void> _editChecklistBinding(
    BuildContext context,
    WidgetRef ref, {
    required String checklistId,
    required ChecklistReferenceData referenceData,
    ChecklistBinding? binding,
  }) async {
    final result = await showDialog<_ChecklistBindingFormResult>(
      context: context,
      builder: (context) => _ChecklistBindingDialog(
        referenceData: referenceData,
        binding: binding,
      ),
    );
    if (result == null) {
      return;
    }

    try {
      await ref.read(checklistsRepositoryProvider).saveChecklistBinding(
            id: binding?.id,
            checklistId: checklistId,
            targetType: result.targetType,
            targetId: result.targetId,
            targetObjectType: result.targetObjectType,
            priority: result.priority,
            isRequired: result.isRequired,
          );
      _invalidateChecklistState(ref, checklistId);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showChecklistMessage(context, error.message.toString());
    }
  }

  Future<void> _deleteChecklistBinding(
    BuildContext context,
    WidgetRef ref, {
    required String checklistId,
    required String bindingId,
  }) async {
    await ref.read(checklistsRepositoryProvider).deleteChecklistBinding(bindingId);
    _invalidateChecklistState(ref, checklistId);
  }
}

class _ChecklistSectionHeader extends StatelessWidget {
  const _ChecklistSectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          OutlinedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _ChecklistEditorDialog extends StatefulWidget {
  const _ChecklistEditorDialog({this.checklist});

  final Checklist? checklist;

  @override
  State<_ChecklistEditorDialog> createState() => _ChecklistEditorDialogState();
}

class _ChecklistEditorDialogState extends State<_ChecklistEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.checklist?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.checklist?.description ?? '',
    );
    _isActive = widget.checklist?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.checklist == null ? 'Новый чек-лист' : 'Редактировать чек-лист'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Активен'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              _ChecklistFormResult(
                name: _nameController.text,
                description: _descriptionController.text,
                isActive: _isActive,
              ),
            );
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _ChecklistItemDialog extends StatefulWidget {
  const _ChecklistItemDialog({
    required this.referenceData,
    this.item,
  });

  final ChecklistReferenceData referenceData;
  final ChecklistItem? item;

  @override
  State<_ChecklistItemDialog> createState() => _ChecklistItemDialogState();
}

class _ChecklistItemDialogState extends State<_ChecklistItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _expectedResultController;
  late final TextEditingController _sortController;
  String? _componentId;
  late String _resultType;
  late bool _isRequired;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _expectedResultController = TextEditingController(
      text: widget.item?.expectedResult ?? '',
    );
    _sortController = TextEditingController(text: '${widget.item?.sortOrder ?? 0}');
    _componentId = widget.item?.componentId;
    _resultType = widget.item?.resultType ?? checklistResultTypeOptions.first;
    _isRequired = widget.item?.isRequired ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _expectedResultController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Новый пункт' : 'Редактировать пункт'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: _componentId,
                  decoration: const InputDecoration(labelText: 'Компонент'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Без привязки к компоненту'),
                    ),
                    for (final component in widget.referenceData.components)
                      DropdownMenuItem<String?>(
                        value: component.id,
                        child: Text(component.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => _componentId = value),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _resultType,
                  decoration: const InputDecoration(labelText: 'Тип результата'),
                  items: [
                    for (final value in checklistResultTypeOptions)
                      DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                  ],
                  onChanged: (value) => setState(() => _resultType = value ?? _resultType),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Заголовок'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Введите заголовок' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 2,
                ),
                TextFormField(
                  controller: _expectedResultController,
                  decoration: const InputDecoration(labelText: 'Ожидаемый результат'),
                  maxLines: 2,
                ),
                TextFormField(
                  controller: _sortController,
                  decoration: const InputDecoration(labelText: 'Порядок'),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Обязательный пункт'),
                  value: _isRequired,
                  onChanged: (value) => setState(() => _isRequired = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              _ChecklistItemFormResult(
                componentId: _componentId,
                title: _titleController.text,
                description: _descriptionController.text,
                expectedResult: _expectedResultController.text,
                resultType: _resultType,
                isRequired: _isRequired,
                sortOrder: int.tryParse(_sortController.text) ?? 0,
              ),
            );
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _ChecklistBindingDialog extends StatefulWidget {
  const _ChecklistBindingDialog({
    required this.referenceData,
    this.binding,
  });

  final ChecklistReferenceData referenceData;
  final ChecklistBinding? binding;

  @override
  State<_ChecklistBindingDialog> createState() => _ChecklistBindingDialogState();
}

class _ChecklistBindingDialogState extends State<_ChecklistBindingDialog> {
  late String _targetType;
  String? _targetId;
  String? _targetObjectType;
  late bool _isRequired;
  late final TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    _targetType = widget.binding?.targetType ?? checklistBindingTypeOptions.first;
    _targetId = widget.binding?.targetId;
    _targetObjectType = widget.binding?.targetObjectType;
    _isRequired = widget.binding?.isRequired ?? true;
    _priorityController = TextEditingController(
      text: '${widget.binding?.priority ?? 0}',
    );
  }

  @override
  void dispose() {
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.referenceData.objects
        .where((object) => object.type == 'product')
        .toList(growable: false);

    return AlertDialog(
      title: Text(widget.binding == null ? 'Новая привязка' : 'Редактировать привязку'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _targetType,
              decoration: const InputDecoration(labelText: 'Тип привязки'),
              items: [
                for (final value in checklistBindingTypeOptions)
                  DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
              ],
              onChanged: (value) => setState(() => _targetType = value ?? _targetType),
            ),
            if (_targetType == 'object')
              DropdownButtonFormField<String?>(
                initialValue: _targetId,
                decoration: const InputDecoration(labelText: 'Объект'),
                items: [
                  for (final object in widget.referenceData.objects)
                    DropdownMenuItem<String?>(
                      value: object.id,
                      child: Text(object.name),
                    ),
                ],
                onChanged: (value) => setState(() => _targetId = value),
              ),
            if (_targetType == 'product')
              DropdownButtonFormField<String?>(
                initialValue: _targetId,
                decoration: const InputDecoration(labelText: 'Изделие'),
                items: [
                  for (final object in products)
                    DropdownMenuItem<String?>(
                      value: object.id,
                      child: Text(object.name),
                    ),
                ],
                onChanged: (value) => setState(() => _targetId = value),
              ),
            if (_targetType == 'object_type')
              DropdownButtonFormField<String?>(
                initialValue: _targetObjectType,
                decoration: const InputDecoration(labelText: 'Тип объекта'),
                items: [
                  for (final value in objectTypeOptions)
                    DropdownMenuItem<String?>(
                      value: value,
                      child: Text(value),
                    ),
                ],
                onChanged: (value) => setState(() => _targetObjectType = value),
              ),
            TextFormField(
              controller: _priorityController,
              decoration: const InputDecoration(labelText: 'Приоритет'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Обязательная привязка'),
              value: _isRequired,
              onChanged: (value) => setState(() => _isRequired = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              _ChecklistBindingFormResult(
                targetType: _targetType,
                targetId: _targetId,
                targetObjectType: _targetObjectType,
                priority: int.tryParse(_priorityController.text) ?? 0,
                isRequired: _isRequired,
              ),
            );
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _ChecklistFormResult {
  const _ChecklistFormResult({
    required this.name,
    required this.description,
    required this.isActive,
  });

  final String name;
  final String description;
  final bool isActive;
}

class _ChecklistItemFormResult {
  const _ChecklistItemFormResult({
    required this.componentId,
    required this.title,
    required this.description,
    required this.expectedResult,
    required this.resultType,
    required this.isRequired,
    required this.sortOrder,
  });

  final String? componentId;
  final String title;
  final String description;
  final String expectedResult;
  final String resultType;
  final bool isRequired;
  final int sortOrder;
}

class _ChecklistBindingFormResult {
  const _ChecklistBindingFormResult({
    required this.targetType,
    required this.targetId,
    required this.targetObjectType,
    required this.priority,
    required this.isRequired,
  });

  final String targetType;
  final String? targetId;
  final String? targetObjectType;
  final int priority;
  final bool isRequired;
}

void _invalidateChecklistState(WidgetRef ref, String checklistId) {
  ref.invalidate(checklistsProvider);
  ref.invalidate(checklistReferenceDataProvider);
  ref.invalidate(checklistDetailProvider(checklistId));
}

String _bindingTitle(
  ChecklistBinding binding,
  ChecklistReferenceData referenceData,
) {
  return switch (binding.targetType) {
    'object' => 'Объект: ${_objectName(referenceData, binding.targetId)}',
    'product' => 'Изделие: ${_objectName(referenceData, binding.targetId)}',
    'object_type' => 'Тип объекта: ${binding.targetObjectType ?? 'не задан'}',
    _ => '${binding.targetType}: ${binding.targetId ?? '-'}',
  };
}

String _objectName(ChecklistReferenceData referenceData, String? objectId) {
  if (objectId == null) {
    return 'не задан';
  }

  final object = referenceData.objects.firstWhere(
    (candidate) => candidate.id == objectId,
    orElse: () => _fallbackBindingObject,
  );
  return object.name.isEmpty ? 'не найден' : object.name;
}

final _fallbackBindingObject = CatalogObject(
  id: '',
  type: 'product',
  sectionId: null,
  parentId: null,
  name: '',
  code: null,
  description: null,
  sortOrder: 0,
  isActive: true,
  version: 1,
  createdAt: '',
  updatedAt: '',
  deletedAt: null,
  isDeleted: false,
);

void _showChecklistMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
