import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/user_message.dart';
import '../../admin/data/admin_repositories.dart';
import '../../auth/data/auth_service.dart';
import '../data/master_data_repositories.dart';

final _selectedComponentObjectIdProvider = StateProvider<String?>(
  (ref) => null,
);
final _selectedComponentIdProvider = StateProvider<String?>((ref) => null);

class ComponentsAdminScreen extends ConsumerWidget {
  const ComponentsAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataAsync = ref.watch(componentsScreenDataProvider);
    final canEdit = ref.watch(isAdministratorProvider);

    return screenDataAsync.when(
      data: (screenData) {
        final selectedObjectId =
            ref.watch(_selectedComponentObjectIdProvider) ??
            (screenData.objects.isNotEmpty
                ? screenData.objects.first.id
                : null);
        final selectedObject = screenData.objects.firstWhere(
          (object) => object.id == selectedObjectId,
          orElse: () => screenData.objects.isNotEmpty
              ? screenData.objects.first
              : _emptyCatalogObject,
        );
        final componentsAsync = ref.watch(
          componentsByObjectProvider(selectedObjectId),
        );

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!canEdit)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Редактирование доступно только администратору.'),
                ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedObjectId,
                      decoration: const InputDecoration(
                        labelText: 'Объект для компонентов',
                      ),
                      items: [
                        for (final object in screenData.objects)
                          DropdownMenuItem(
                            value: object.id,
                            child: Text('${object.name} (${object.type})'),
                          ),
                      ],
                      onChanged: (value) {
                        ref
                                .read(
                                  _selectedComponentObjectIdProvider.notifier,
                                )
                                .state =
                            value;
                        ref.read(_selectedComponentIdProvider.notifier).state =
                            null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: canEdit && selectedObjectId != null
                        ? () => _editComponent(
                            context,
                            ref,
                            objectId: selectedObjectId,
                          )
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить компонент'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (selectedObjectId == null)
                const Expanded(
                  child: Center(child: Text('Сначала создайте объект.')),
                )
              else
                Expanded(
                  child: componentsAsync.when(
                    data: (components) {
                      final selectedComponentId =
                          ref.watch(_selectedComponentIdProvider) ??
                          (components.isNotEmpty ? components.first.id : null);
                      final selectedComponent = components.firstWhere(
                        (component) => component.id == selectedComponentId,
                        orElse: () => components.isNotEmpty
                            ? components.first
                            : _emptyComponent,
                      );
                      final imagesAsync = selectedComponentId == null
                          ? null
                          : ref.watch(
                              componentImagesProvider(selectedComponentId),
                            );

                      return Row(
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
                                    Text(
                                      'Компоненты объекта "${selectedObject.name}"',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    if (components.isEmpty)
                                      const Expanded(
                                        child: Center(
                                          child: Text(
                                            'Для этого объекта пока нет компонентов.',
                                          ),
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: ListView(
                                          children: [
                                            for (final component in components)
                                              Card(
                                                child: ListTile(
                                                  title: Text(component.name),
                                                  subtitle: Text(
                                                    component.code ??
                                                        'Без кода',
                                                  ),
                                                  selected:
                                                      component.id ==
                                                      selectedComponent.id,
                                                  onTap: () =>
                                                      ref
                                                          .read(
                                                            _selectedComponentIdProvider
                                                                .notifier,
                                                          )
                                                          .state = component
                                                          .id,
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
                            flex: 4,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: components.isEmpty
                                    ? const Text(
                                        'Выберите или создайте компонент.',
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedComponent.name,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: canEdit
                                                    ? () => _editComponent(
                                                        context,
                                                        ref,
                                                        objectId:
                                                            selectedObjectId,
                                                        component:
                                                            selectedComponent,
                                                      )
                                                    : null,
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: canEdit
                                                    ? () => _deleteComponent(
                                                        context,
                                                        ref,
                                                        selectedComponent.id,
                                                      )
                                                    : null,
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          _ComponentDetailRow(
                                            'Код',
                                            selectedComponent.code ??
                                                'Не указан',
                                          ),
                                          _ComponentDetailRow(
                                            'Обязательный',
                                            selectedComponent.isRequired
                                                ? 'Да'
                                                : 'Нет',
                                          ),
                                          if ((selectedComponent.description ??
                                                  '')
                                              .isNotEmpty)
                                            _ComponentDetailRow(
                                              'Описание',
                                              selectedComponent.description!,
                                            ),
                                          const Divider(height: 32),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Изображения',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                ),
                                              ),
                                              OutlinedButton.icon(
                                                onPressed: canEdit
                                                    ? () => _importImages(
                                                        context,
                                                        ref,
                                                        selectedComponent.id,
                                                      )
                                                    : null,
                                                icon: const Icon(
                                                  Icons.upload_file_outlined,
                                                ),
                                                label: const Text(
                                                  'Импортировать',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child:
                                                imagesAsync?.when(
                                                  data: (images) =>
                                                      images.isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                            'Изображения пока не импортированы.',
                                                          ),
                                                        )
                                                      : ListView(
                                                          children: [
                                                            for (final image
                                                                in images)
                                                              Card(
                                                                child: ListTile(
                                                                  title: Text(
                                                                    image
                                                                        .fileName,
                                                                  ),
                                                                  subtitle: Text(
                                                                    image.localPath ??
                                                                        '-',
                                                                  ),
                                                                  trailing: IconButton(
                                                                    onPressed:
                                                                        canEdit
                                                                        ? () => _deleteImage(
                                                                            context,
                                                                            ref,
                                                                            selectedComponent.id,
                                                                            image.id,
                                                                          )
                                                                        : null,
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                  loading: () => const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  error: (error, _) => Center(
                                                    child: Text(
                                                      'Не удалось загрузить изображения. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
                                                    ),
                                                  ),
                                                ) ??
                                                const SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Text(
                        'Не удалось загрузить компоненты. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
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
          'Не удалось загрузить объекты. ${userMessageFromError(error, fallback: 'Повторите попытку позже.')}',
        ),
      ),
    );
  }

  Future<void> _editComponent(
    BuildContext context,
    WidgetRef ref, {
    required String objectId,
    Component? component,
  }) async {
    final result = await showDialog<_ComponentFormResult>(
      context: context,
      builder: (context) => _ComponentEditorDialog(component: component),
    );
    if (result == null) {
      return;
    }

    try {
      await ref
          .read(componentsRepositoryProvider)
          .saveComponent(
            id: component?.id,
            objectId: objectId,
            name: result.name,
            code: result.code,
            description: result.description,
            sortOrder: result.sortOrder,
            isRequired: result.isRequired,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          );
      ref.invalidate(componentsScreenDataProvider);
      ref.invalidate(componentsByObjectProvider(objectId));
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showComponentsMessage(context, error.message.toString());
    }
  }

  Future<void> _deleteComponent(
    BuildContext context,
    WidgetRef ref,
    String componentId,
  ) async {
    try {
      await ref
          .read(componentsRepositoryProvider)
          .deleteComponent(
            componentId,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          );
      ref.invalidate(componentsScreenDataProvider);
      final objectId = ref.read(_selectedComponentObjectIdProvider);
      ref.invalidate(componentsByObjectProvider(objectId));
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showComponentsMessage(context, error.message.toString());
    }
  }

  Future<void> _importImages(
    BuildContext context,
    WidgetRef ref,
    String componentId,
  ) async {
    final result = await showDialog<_ImageImportResult>(
      context: context,
      builder: (context) => const _ImageImportDialog(),
    );
    if (result == null) {
      return;
    }

    try {
      await ref
          .read(componentImagesRepositoryProvider)
          .importImages(
            componentId: componentId,
            sourcePaths: result.paths,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          );
      ref.invalidate(componentImagesProvider(componentId));
      ref.invalidate(auditEntriesProvider);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showComponentsMessage(context, error.message.toString());
    }
  }

  Future<void> _deleteImage(
    BuildContext context,
    WidgetRef ref,
    String componentId,
    String imageId,
  ) async {
    await ref
        .read(componentImagesRepositoryProvider)
        .deleteImage(
          imageId,
          actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
        );
    ref.invalidate(componentImagesProvider(componentId));
    ref.invalidate(trashEntriesProvider);
    ref.invalidate(auditEntriesProvider);
  }
}

final _emptyCatalogObject = CatalogObject(
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

final _emptyComponent = Component(
  id: '',
  objectId: '',
  name: '',
  code: null,
  description: null,
  sortOrder: 0,
  isRequired: true,
  version: 1,
  createdAt: '',
  updatedAt: '',
  deletedAt: null,
  isDeleted: false,
);

class _ComponentDetailRow extends StatelessWidget {
  const _ComponentDetailRow(this.label, this.value);

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

class _ComponentEditorDialog extends StatefulWidget {
  const _ComponentEditorDialog({this.component});

  final Component? component;

  @override
  State<_ComponentEditorDialog> createState() => _ComponentEditorDialogState();
}

class _ComponentEditorDialogState extends State<_ComponentEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortController;
  late bool _isRequired;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.component?.name ?? '');
    _codeController = TextEditingController(text: widget.component?.code ?? '');
    _descriptionController = TextEditingController(
      text: widget.component?.description ?? '',
    );
    _sortController = TextEditingController(
      text: '${widget.component?.sortOrder ?? 0}',
    );
    _isRequired = widget.component?.isRequired ?? true;
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
    return AlertDialog(
      title: Text(
        widget.component == null
            ? 'Новый компонент'
            : 'Редактирование компонента',
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Введите название'
                    : null,
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
                decoration: const InputDecoration(
                  labelText: 'Порядок сортировки',
                ),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Обязательный компонент'),
                value: _isRequired,
                onChanged: (value) => setState(() => _isRequired = value),
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
              _ComponentFormResult(
                name: _nameController.text,
                code: _codeController.text,
                description: _descriptionController.text,
                sortOrder: int.tryParse(_sortController.text) ?? 0,
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

class _ImageImportDialog extends StatefulWidget {
  const _ImageImportDialog();

  @override
  State<_ImageImportDialog> createState() => _ImageImportDialogState();
}

class _ImageImportDialogState extends State<_ImageImportDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Импорт изображений'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Укажите по одному пути к исходному файлу на строку.'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'C:\\images\\part_1.png',
              ),
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
            final paths = _controller.text
                .split(RegExp(r'\r?\n'))
                .map((path) => path.trim())
                .where((path) => path.isNotEmpty)
                .toList(growable: false);
            Navigator.of(context).pop(_ImageImportResult(paths));
          },
          child: const Text('Импортировать'),
        ),
      ],
    );
  }
}

class _ComponentFormResult {
  const _ComponentFormResult({
    required this.name,
    required this.code,
    required this.description,
    required this.sortOrder,
    required this.isRequired,
  });

  final String name;
  final String code;
  final String description;
  final int sortOrder;
  final bool isRequired;
}

class _ImageImportResult {
  const _ImageImportResult(this.paths);

  final List<String> paths;
}

void _showComponentsMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
