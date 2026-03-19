import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/platform/app_platform.dart';
import '../data/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pinController = TextEditingController();
  String? _selectedUserId;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(loginUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Local login')),
      body: usersAsync.when(
        data: (users) {
          final selectedUserId =
              _selectedUserId ?? (users.isNotEmpty ? users.first.userId : null);
          final selectedUser = users.cast<LoginUserOption?>().firstWhere(
                (user) => user?.userId == selectedUserId,
                orElse: () => null,
              );

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a local user',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (users.isEmpty)
                      const Text('No active users are available.')
                    else ...[
                      DropdownButtonFormField<String>(
                        initialValue: selectedUserId,
                        decoration: const InputDecoration(labelText: 'User'),
                        items: [
                          for (final user in users)
                            DropdownMenuItem(
                              value: user.userId,
                              child: Text('${user.fullName} (${user.roleCode})'),
                            ),
                        ],
                        onChanged: (value) => setState(() => _selectedUserId = value),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: selectedUser?.requiresPin == true
                              ? 'PIN'
                              : 'PIN (optional)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: selectedUserId == null
                            ? null
                            : () => _login(context, selectedUserId),
                        child: const Text('Login'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load users: $error')),
      ),
    );
  }

  Future<void> _login(BuildContext context, String userId) async {
    try {
      await ref.read(authServiceProvider).login(
            userId: userId,
            pin: _pinController.text,
          );
      refreshAuthProviders(ref);
      if (!context.mounted) {
        return;
      }
      context.go(getAppPlatform() == AppPlatform.windows ? '/windows' : '/');
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }
}
