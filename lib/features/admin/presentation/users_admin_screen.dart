import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/sqlite/app_database.dart';
import '../../auth/data/auth_service.dart';
import '../data/admin_repositories.dart';

final _selectedManagedUserIdProvider = StateProvider<String?>((ref) => null);

class UsersAdminScreen extends ConsumerWidget {
  const UsersAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final rolesAsync = ref.watch(rolesProvider);
    final session = ref.watch(activeSessionProvider).valueOrNull;
    final canEdit = ref.watch(isAdministratorProvider);

    return usersAsync.when(
      data: (users) => rolesAsync.when(
        data: (roles) {
          final selectedId = ref.watch(_selectedManagedUserIdProvider) ??
              (users.isNotEmpty ? users.first.user.id : null);
          final selectedUser = users.firstWhere(
            (user) => user.user.id == selectedId,
            orElse: () => users.isNotEmpty ? users.first : _fallbackManagedUser,
          );

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
                                  'Users',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              FilledButton.icon(
                                onPressed: canEdit
                                    ? () => _editUser(context, ref, roles: roles)
                                    : null,
                                icon: const Icon(Icons.add),
                                label: const Text('Add'),
                              ),
                            ],
                          ),
                          if (!canEdit) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Editing is available only for the administrator role.',
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (users.isEmpty)
                            const Expanded(
                              child: Center(
                                child: Text('No users configured yet.'),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView(
                                children: [
                                  for (final managedUser in users)
                                    Card(
                                      child: ListTile(
                                        selected: managedUser.user.id == selectedUser.user.id,
                                        title: Text(managedUser.user.fullName),
                                        subtitle: Text(
                                          '${managedUser.role.name} • ${managedUser.user.isActive ? 'active' : 'inactive'}',
                                        ),
                                        trailing: managedUser.user.id == session?.userId
                                            ? const Icon(Icons.verified_user_outlined)
                                            : null,
                                        onTap: () => ref
                                            .read(_selectedManagedUserIdProvider.notifier)
                                            .state = managedUser.user.id,
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
                      child: users.isEmpty
                          ? const Text('Create the first user to manage local access.')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedUser.user.fullName,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: canEdit
                                          ? () => _editUser(
                                                context,
                                                ref,
                                                roles: roles,
                                                user: selectedUser,
                                              )
                                          : null,
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      onPressed: canEdit
                                          ? () => _deleteUser(
                                                context,
                                                ref,
                                                selectedUser,
                                                session?.userId,
                                              )
                                          : null,
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _UserDetailRow('Short name', selectedUser.user.shortName ?? '—'),
                                _UserDetailRow('Role', selectedUser.role.name),
                                _UserDetailRow(
                                  'Status',
                                  selectedUser.user.isActive ? 'Active' : 'Inactive',
                                ),
                                _UserDetailRow(
                                  'PIN',
                                  (selectedUser.user.pinHash ?? '').isEmpty
                                      ? 'Not set'
                                      : 'Configured',
                                ),
                                _UserDetailRow(
                                  'Last login',
                                  selectedUser.user.lastLoginAt ?? 'Never',
                                ),
                                if (selectedUser.user.id == session?.userId) ...[
                                  const Divider(height: 32),
                                  const Text('This user is currently active in the local session.'),
                                ],
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
        error: (error, _) => Center(child: Text('Failed to load roles: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load users: $error')),
    );
  }

  Future<void> _editUser(
    BuildContext context,
    WidgetRef ref, {
    required List<Role> roles,
    ManagedUser? user,
  }) async {
    final result = await showDialog<_UserFormResult>(
      context: context,
      builder: (context) => _UserEditorDialog(
        roles: roles,
        user: user,
      ),
    );
    if (result == null) {
      return;
    }

    final actorUserId = ref.watch(activeSessionProvider).valueOrNull?.userId;
    await ref.read(usersRepositoryProvider).saveUser(
          id: user?.user.id,
          fullName: result.fullName,
          shortName: result.shortName,
          roleId: result.roleId,
          isActive: result.isActive,
          pin: result.pin,
          actorUserId: actorUserId,
        );
    ref.invalidate(usersProvider);
    ref.invalidate(rolesProvider);
    refreshAuthProviders(ref);
  }

  Future<void> _deleteUser(
    BuildContext context,
    WidgetRef ref,
    ManagedUser user,
    String? actorUserId,
  ) async {
    if (actorUserId == user.user.id) {
      _showUserMessage(context, 'The active session user cannot be deleted.');
      return;
    }

    await ref.read(usersRepositoryProvider).deleteUser(
          user.user.id,
          actorUserId: actorUserId,
        );
    ref.invalidate(usersProvider);
    ref.invalidate(rolesProvider);
    refreshAuthProviders(ref);
  }
}

class _UserDetailRow extends StatelessWidget {
  const _UserDetailRow(this.label, this.value);

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

class _UserEditorDialog extends StatefulWidget {
  const _UserEditorDialog({
    required this.roles,
    this.user,
  });

  final List<Role> roles;
  final ManagedUser? user;

  @override
  State<_UserEditorDialog> createState() => _UserEditorDialogState();
}

class _UserEditorDialogState extends State<_UserEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _shortNameController;
  late final TextEditingController _pinController;
  late String _roleId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user?.user.fullName ?? '');
    _shortNameController =
        TextEditingController(text: widget.user?.user.shortName ?? '');
    _pinController = TextEditingController();
    _roleId = widget.user?.role.id ?? widget.roles.first.id;
    _isActive = widget.user?.user.isActive ?? true;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _shortNameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'New user' : 'Edit user'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Enter full name' : null,
              ),
              TextFormField(
                controller: _shortNameController,
                decoration: const InputDecoration(labelText: 'Short name'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _roleId,
                decoration: const InputDecoration(labelText: 'Role'),
                items: [
                  for (final role in widget.roles)
                    DropdownMenuItem(
                      value: role.id,
                      child: Text(role.name),
                    ),
                ],
                onChanged: (value) => setState(() => _roleId = value ?? _roleId),
              ),
              TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: widget.user == null ? 'PIN' : 'PIN (leave blank to keep)',
                ),
                obscureText: true,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
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
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              _UserFormResult(
                fullName: _fullNameController.text,
                shortName: _shortNameController.text,
                roleId: _roleId,
                pin: _pinController.text,
                isActive: _isActive,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _UserFormResult {
  const _UserFormResult({
    required this.fullName,
    required this.shortName,
    required this.roleId,
    required this.pin,
    required this.isActive,
  });

  final String fullName;
  final String shortName;
  final String roleId;
  final String pin;
  final bool isActive;
}

final _fallbackManagedUser = ManagedUser(
  user: User(
    id: '',
    fullName: '',
    shortName: null,
    roleId: '',
    pinHash: null,
    isActive: true,
    lastLoginAt: null,
    version: 1,
    createdAt: '',
    updatedAt: '',
    deletedAt: null,
    isDeleted: false,
  ),
  role: Role(
    id: '',
    code: 'viewer',
    name: '',
    description: null,
    createdAt: '',
    updatedAt: '',
  ),
);

void _showUserMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
