import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_service.dart';
import '../data/master_data_repositories.dart';

final _selectedDepartmentIdProvider = StateProvider<String?>((ref) => null);
final _selectedWorkshopIdProvider = StateProvider<String?>((ref) => null);
final _selectedSectionIdProvider = StateProvider<String?>((ref) => null);

class StructureAdminScreen extends ConsumerWidget {
  const StructureAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeAsync = ref.watch(structureTreeProvider);
    final canEdit = ref.watch(isAdministratorProvider);

    return treeAsync.when(
      data: (tree) {
        final selectedDepartmentId = ref.watch(_selectedDepartmentIdProvider);
        final departmentNode = tree.firstWhere(
          (node) => node.department.id == selectedDepartmentId,
          orElse: () => tree.isNotEmpty ? tree.first : _emptyDepartmentNode,
        );
        final selectedWorkshopId = ref.watch(_selectedWorkshopIdProvider);
        final workshopNode = departmentNode.workshops.firstWhere(
          (node) => node.workshop.id == selectedWorkshopId,
          orElse: () => departmentNode.workshops.isNotEmpty
              ? departmentNode.workshops.first
              : _emptyWorkshopNode,
        );
        final selectedSectionId = ref.watch(_selectedSectionIdProvider);
        final selectedSection = workshopNode.sections.firstWhere(
          (section) => section.id == selectedSectionId,
          orElse: () => workshopNode.sections.isNotEmpty
              ? workshopNode.sections.first
              : _emptySection,
        );

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!canEdit)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Editing is available only for the administrator role.',
                  ),
                ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StructureColumn(
                        title: 'Departments',
                        addLabel: 'Add department',
                        onAdd: canEdit ? () => _editDepartment(context, ref) : null,
                        onEdit: !canEdit || tree.isEmpty
                            ? null
                            : () => _editDepartment(
                                  context,
                                  ref,
                                  department: departmentNode.department,
                                ),
                        onDelete: !canEdit || tree.isEmpty
                            ? null
                            : () => _deleteDepartment(
                                  context,
                                  ref,
                                  departmentNode.department.id,
                                ),
                        children: [
                          for (final node in tree)
                            _SelectableTile(
                              title: node.department.name,
                              subtitle: node.department.code ?? 'No code',
                              selected: node.department.id == departmentNode.department.id,
                              onTap: () {
                                ref.read(_selectedDepartmentIdProvider.notifier).state =
                                    node.department.id;
                                ref.read(_selectedWorkshopIdProvider.notifier).state = null;
                                ref.read(_selectedSectionIdProvider.notifier).state = null;
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StructureColumn(
                        title: 'Workshops',
                        addLabel: 'Add workshop',
                        onAdd: !canEdit || tree.isEmpty
                            ? null
                            : () => _editWorkshop(
                                  context,
                                  ref,
                                  departments: tree,
                                  initialDepartmentId: departmentNode.department.id,
                                ),
                        onEdit: !canEdit || departmentNode.workshops.isEmpty
                            ? null
                            : () => _editWorkshop(
                                  context,
                                  ref,
                                  departments: tree,
                                  workshop: workshopNode.workshop,
                                  initialDepartmentId: departmentNode.department.id,
                                ),
                        onDelete: !canEdit || departmentNode.workshops.isEmpty
                            ? null
                            : () => _deleteWorkshop(
                                  context,
                                  ref,
                                  workshopNode.workshop.id,
                                ),
                        children: [
                          for (final node in departmentNode.workshops)
                            _SelectableTile(
                              title: node.workshop.name,
                              subtitle: node.workshop.code ?? 'No code',
                              selected: node.workshop.id == workshopNode.workshop.id,
                              onTap: () {
                                ref.read(_selectedWorkshopIdProvider.notifier).state =
                                    node.workshop.id;
                                ref.read(_selectedSectionIdProvider.notifier).state = null;
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StructureColumn(
                        title: 'Sections',
                        addLabel: 'Add section',
                        onAdd: !canEdit || departmentNode.workshops.isEmpty
                            ? null
                            : () => _editSection(
                                  context,
                                  ref,
                                  departments: tree,
                                  initialWorkshopId: workshopNode.workshop.id,
                                ),
                        onEdit: !canEdit || workshopNode.sections.isEmpty
                            ? null
                            : () => _editSection(
                                  context,
                                  ref,
                                  departments: tree,
                                  section: selectedSection,
                                  initialWorkshopId: workshopNode.workshop.id,
                                ),
                        onDelete: !canEdit || workshopNode.sections.isEmpty
                            ? null
                            : () => _deleteSection(
                                  context,
                                  ref,
                                  selectedSection.id,
                                ),
                        children: [
                          for (final section in workshopNode.sections)
                            _SelectableTile(
                              title: section.name,
                              subtitle: section.code ?? 'No code',
                              selected: section.id == selectedSection.id,
                              onTap: () {
                                ref.read(_selectedSectionIdProvider.notifier).state =
                                    section.id;
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load structure: $error')),
    );
  }

  Future<void> _editDepartment(
    BuildContext context,
    WidgetRef ref, {
    Department? department,
  }) async {
    final result = await showDialog<_StructureFormResult>(
      context: context,
      builder: (context) => _NameCodeSortDialog(
        title: department == null ? 'New department' : 'Edit department',
        initialName: department?.name,
        initialCode: department?.code,
        initialSortOrder: department?.sortOrder ?? 0,
      ),
    );
    if (result == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).saveDepartment(
            id: department?.id,
            name: result.name,
            code: result.code,
            sortOrder: result.sortOrder,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _editWorkshop(
    BuildContext context,
    WidgetRef ref, {
    required List<DepartmentNode> departments,
    Workshop? workshop,
    required String initialDepartmentId,
  }) async {
    final result = await showDialog<_ParentFormResult>(
      context: context,
      builder: (context) => _ParentSelectionDialog(
        title: workshop == null ? 'New workshop' : 'Edit workshop',
        parentLabel: 'Department',
        parentOptions: [
          for (final node in departments)
            DropdownMenuItem<String>(
              value: node.department.id,
              child: Text(node.department.name),
            ),
        ],
        initialParentId: workshop?.departmentId ?? initialDepartmentId,
        initialName: workshop?.name,
        initialCode: workshop?.code,
        initialSortOrder: workshop?.sortOrder ?? 0,
      ),
    );
    if (result == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).saveWorkshop(
            id: workshop?.id,
            departmentId: result.parentId,
            name: result.name,
            code: result.code,
            sortOrder: result.sortOrder,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _editSection(
    BuildContext context,
    WidgetRef ref, {
    required List<DepartmentNode> departments,
    Section? section,
    required String initialWorkshopId,
  }) async {
    final workshops = [
      for (final department in departments) ...department.workshops,
    ];
    final result = await showDialog<_ParentFormResult>(
      context: context,
      builder: (context) => _ParentSelectionDialog(
        title: section == null ? 'New section' : 'Edit section',
        parentLabel: 'Workshop',
        parentOptions: [
          for (final workshopNode in workshops)
            DropdownMenuItem<String>(
              value: workshopNode.workshop.id,
              child: Text(workshopNode.workshop.name),
            ),
        ],
        initialParentId: section?.workshopId ?? initialWorkshopId,
        initialName: section?.name,
        initialCode: section?.code,
        initialSortOrder: section?.sortOrder ?? 0,
      ),
    );
    if (result == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).saveSection(
            id: section?.id,
            workshopId: result.parentId,
            name: result.name,
            code: result.code,
            sortOrder: result.sortOrder,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _deleteDepartment(
    BuildContext context,
    WidgetRef ref,
    String departmentId,
  ) async {
    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).deleteDepartment(
            departmentId,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _deleteWorkshop(
    BuildContext context,
    WidgetRef ref,
    String workshopId,
  ) async {
    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).deleteWorkshop(
            workshopId,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _deleteSection(
    BuildContext context,
    WidgetRef ref,
    String sectionId,
  ) async {
    await _runGuarded(
      context,
      ref,
      () => ref.read(enterpriseStructureRepositoryProvider).deleteSection(
            sectionId,
            actorUserId: ref.read(activeSessionProvider).valueOrNull?.userId,
          ),
    );
  }

  Future<void> _runGuarded(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      ref.invalidate(structureTreeProvider);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      _showMessage(context, error.message.toString());
    }
  }
}

final _emptyDepartmentNode = DepartmentNode(
  department: Department(
    id: '',
    name: '',
    code: null,
    sortOrder: 0,
    version: 1,
    createdAt: '',
    updatedAt: '',
    deletedAt: null,
    isDeleted: false,
  ),
  workshops: const [],
);

final _emptyWorkshopNode = WorkshopNode(
  workshop: Workshop(
    id: '',
    departmentId: '',
    name: '',
    code: null,
    sortOrder: 0,
    version: 1,
    createdAt: '',
    updatedAt: '',
    deletedAt: null,
    isDeleted: false,
  ),
  sections: const [],
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

class _StructureColumn extends StatelessWidget {
  const _StructureColumn({
    required this.title,
    required this.addLabel,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.children,
  });

  final String title;
  final String addLabel;
  final VoidCallback? onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(addLabel),
            ),
            const SizedBox(height: 16),
            if (children.isEmpty)
              const Text('Nothing here yet.')
            else
              ...children,
          ],
        ),
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}

class _NameCodeSortDialog extends StatefulWidget {
  const _NameCodeSortDialog({
    required this.title,
    this.initialName,
    this.initialCode,
    required this.initialSortOrder,
  });

  final String title;
  final String? initialName;
  final String? initialCode;
  final int initialSortOrder;

  @override
  State<_NameCodeSortDialog> createState() => _NameCodeSortDialogState();
}

class _NameCodeSortDialogState extends State<_NameCodeSortDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _sortController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _codeController = TextEditingController(text: widget.initialCode ?? '');
    _sortController = TextEditingController(text: '${widget.initialSortOrder}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              TextFormField(
                controller: _sortController,
                decoration: const InputDecoration(labelText: 'Sort order'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context).pop(
              _StructureFormResult(
                name: _nameController.text,
                code: _codeController.text,
                sortOrder: int.tryParse(_sortController.text) ?? 0,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ParentSelectionDialog extends StatefulWidget {
  const _ParentSelectionDialog({
    required this.title,
    required this.parentLabel,
    required this.parentOptions,
    required this.initialParentId,
    this.initialName,
    this.initialCode,
    required this.initialSortOrder,
  });

  final String title;
  final String parentLabel;
  final List<DropdownMenuItem<String>> parentOptions;
  final String initialParentId;
  final String? initialName;
  final String? initialCode;
  final int initialSortOrder;

  @override
  State<_ParentSelectionDialog> createState() => _ParentSelectionDialogState();
}

class _ParentSelectionDialogState extends State<_ParentSelectionDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _sortController;
  late String _parentId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _parentId = widget.initialParentId;
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _codeController = TextEditingController(text: widget.initialCode ?? '');
    _sortController = TextEditingController(text: '${widget.initialSortOrder}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _sortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _parentId,
                items: widget.parentOptions,
                onChanged: (value) => setState(() => _parentId = value ?? _parentId),
                decoration: InputDecoration(labelText: widget.parentLabel),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              TextFormField(
                controller: _sortController,
                decoration: const InputDecoration(labelText: 'Sort order'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context).pop(
              _ParentFormResult(
                parentId: _parentId,
                name: _nameController.text,
                code: _codeController.text,
                sortOrder: int.tryParse(_sortController.text) ?? 0,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _StructureFormResult {
  const _StructureFormResult({
    required this.name,
    required this.code,
    required this.sortOrder,
  });

  final String name;
  final String code;
  final int sortOrder;
}

class _ParentFormResult extends _StructureFormResult {
  const _ParentFormResult({
    required this.parentId,
    required super.name,
    required super.code,
    required super.sortOrder,
  });

  final String parentId;
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
