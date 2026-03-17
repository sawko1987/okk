import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/master_data_repositories.dart';

final _selectedObjectIdProvider = StateProvider<String?>((ref) => null);

class ObjectsAdminScreen extends ConsumerWidget {
  const ObjectsAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(objectsViewDataProvider);

    return dataAsync.when(
      data: (data) {
        final selectedId = ref.watch(_selectedObjectIdProvider);
        final selectedObject = data.allObjects.firstWhere(
          (object) => object.id == selectedId,
          orElse: () => data.allObjects.isNotEmpty ? data.allObjects.first : _emptyObject,
        );

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
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
                                'Дерево объектов',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => _editObject(context, ref, data: data),
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (data.allObjects.isEmpty)
                          const Text('Объекты еще не созданы.')
                        else
                          Expanded(
                            child: ListView(
                              children: [
                                for (final node in data.roots)
                                  ..._buildObjectTiles(
                                    context,
                                    ref,
                                    node,
                                    selectedObject.id,
                                    0,
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
                flex: 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: data.allObjects.isEmpty
                        ? const Text('Выберите или создайте объект.')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedObject.name,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _editObject(
                                      context,
                                      ref,
                                      data: data,
                                      object: selectedObject,
                                    ),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteObject(
                                      context,
                                      ref,
                                      selectedObject.id,
                                    ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _DetailRow('Тип', selectedObject.type),
                              _DetailRow('Код', selectedObject.code ?? 'Без кода'),
                              _DetailRow(
                                'Участок',
                                _sectionName(data, selectedObject.sectionId),
                              ),
                              _DetailRow(
                                'Родитель',
                                _parentName(data, selectedObject.parentId),
                              ),
                              _DetailRow(
                                'Статус',
                                selectedObject.isActive ? 'Активен' : 'Неактивен',
                              ),
                              if ((selectedObject.description ?? '').isNotEmpty)
                                _DetailRow(
                                  'Описание',
                                  selectedObject.description!,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Ошибка загрузки объектов: $error')),
    );
  }

  List<Widget> _buildObjectTiles(
    BuildContext context,
    WidgetRef ref,
    ObjectTreeNode node,
    String selectedObjectId,
    int depth,
  ) {
    return [
      Card(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + depth * 20, right: 16),
          title: Text(node.object.name),
          subtitle: Text('${node.object.type} • ${node.object.code ?? 'без кода'}'),
          selected: node.object.id == selectedObjectId,
          onTap: () =>
              ref.read(_selectedObjectIdProvider.notifier).state = node.object.id,
        ),
      ),
      for (final child in node.children)
        ..._buildObjectTiles(context, ref, child, selectedObjectId, depth + 1),
    ];
  }

  Future<void> _editObject(
    BuildContext context,
    WidgetRef ref, {
    required ObjectsViewData data,
    CatalogObject? object,
  }) async {
    final result = await showDialog<_ObjectFormResult>(
      context: context,
      builder: (context) => _ObjectEditorDialog(
        sections: data.sections,
        objects: data.allObjects,
        object: object,
      ),
    );
    if (result == null) {
      return;
    }

    try {
      await ref.read(objectsRepositoryProvider).saveObject(
            id: object?.id,
            type: result.type,
            sectionId: result.sectionId,
            parentId: result.parentId,
            name: result.name,
            code: result.code,
            description: result.description,
            sortOrder: result.sortOrder,
            isActive: result.isActive,
          );
      ref.invalidate(objectsViewDataProvider);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showObjectsMessage(context, error.message.toString());
    }
  }

  Future<void> _deleteObject(
    BuildContext context,
    WidgetRef ref,
    String objectId,
  ) async {
    try {
      await ref.read(objectsRepositoryProvider).deleteObject(objectId);
      ref.invalidate(objectsViewDataProvider);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showObjectsMessage(context, error.message.toString());
    }
  }

  String _sectionName(ObjectsViewData data, String? sectionId) {
    if (sectionId == null) {
      return 'Не задан';
    }

    return data.sections
            .firstWhere(
              (section) => section.id == sectionId,
              orElse: () => _emptySection,
            )
            .name
            .isEmpty
        ? 'Не найден'
        : data.sections.firstWhere((section) => section.id == sectionId).name;
  }

  String _parentName(ObjectsViewData data, String? parentId) {
    if (parentId == null) {
      return 'Корневой объект';
    }

    return data.allObjects
            .firstWhere(
              (object) => object.id == parentId,
              orElse: () => _emptyObject,
            )
            .name
            .isEmpty
        ? 'Не найден'
        : data.allObjects.firstWhere((object) => object.id == parentId).name;
  }
}

final _emptyObject = CatalogObject(
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

final _emptySection = Section(
  id: '',
  workshopId: '',
  name: '',
  code: null,
  sortOrder: 0,
  version: 1,
  createdAt: '',
  updatedAt: '',
  deletedAt: null,
  isDeleted: false,
);

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

class _ObjectEditorDialog extends StatefulWidget {
  const _ObjectEditorDialog({
    required this.sections,
    required this.objects,
    this.object,
  });

  final List<Section> sections;
  final List<CatalogObject> objects;
  final CatalogObject? object;

  @override
  State<_ObjectEditorDialog> createState() => _ObjectEditorDialogState();
}

class _ObjectEditorDialogState extends State<_ObjectEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortController;
  late String _type;
  String? _sectionId;
  String? _parentId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.object?.name ?? '');
    _codeController = TextEditingController(text: widget.object?.code ?? '');
    _descriptionController = TextEditingController(
      text: widget.object?.description ?? '',
    );
    _sortController = TextEditingController(
      text: '${widget.object?.sortOrder ?? 0}',
    );
    _type = widget.object?.type ?? objectTypeOptions.first;
    _sectionId = widget.object?.sectionId;
    _parentId = widget.object?.parentId;
    _isActive = widget.object?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableParents = widget.objects
        .where((candidate) => candidate.id != widget.object?.id)
        .toList(growable: false);

    return AlertDialog(
      title: Text(widget.object == null ? 'Новый объект' : 'Редактировать объект'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  items: [
                    for (final value in objectTypeOptions)
                      DropdownMenuItem(value: value, child: Text(value)),
                  ],
                  decoration: const InputDecoration(labelText: 'Тип'),
                  onChanged: (value) => setState(() => _type = value ?? _type),
                ),
                DropdownButtonFormField<String?>(
                  initialValue: _sectionId,
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Не задан')),
                    for (final section in widget.sections)
                      DropdownMenuItem<String?>(
                        value: section.id,
                        child: Text(section.name),
                      ),
                  ],
                  decoration: const InputDecoration(labelText: 'Участок'),
                  onChanged: (value) => setState(() => _sectionId = value),
                ),
                DropdownButtonFormField<String?>(
                  initialValue: _parentId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Корневой объект'),
                    ),
                    for (final object in availableParents)
                      DropdownMenuItem<String?>(
                        value: object.id,
                        child: Text(object.name),
                      ),
                  ],
                  decoration: const InputDecoration(labelText: 'Родитель'),
                  onChanged: (value) => setState(() => _parentId = value),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Название'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Введите название' : null,
                ),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Код'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _sortController,
                  decoration: const InputDecoration(labelText: 'Порядок'),
                  keyboardType: TextInputType.number,
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
              _ObjectFormResult(
                type: _type,
                sectionId: _sectionId,
                parentId: _parentId,
                name: _nameController.text,
                code: _codeController.text,
                description: _descriptionController.text,
                sortOrder: int.tryParse(_sortController.text) ?? 0,
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

class _ObjectFormResult {
  const _ObjectFormResult({
    required this.type,
    required this.sectionId,
    required this.parentId,
    required this.name,
    required this.code,
    required this.description,
    required this.sortOrder,
    required this.isActive,
  });

  final String type;
  final String? sectionId;
  final String? parentId;
  final String name;
  final String code;
  final String description;
  final int sortOrder;
  final bool isActive;
}

void _showObjectsMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
