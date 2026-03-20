import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/platform/app_platform.dart';
import '../../../data/sync/sync_service.dart';
import '../../auth/data/auth_service.dart';
import '../data/inspection_repositories.dart';

class AndroidInspectionShell extends ConsumerStatefulWidget {
  const AndroidInspectionShell({super.key});

  @override
  ConsumerState<AndroidInspectionShell> createState() =>
      _AndroidInspectionShellState();
}

class _AndroidInspectionShellState extends ConsumerState<AndroidInspectionShell> {
  int _tabIndex = 0;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Android inspections'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(session.fullName),
            ),
          ),
          IconButton(
            onPressed: () => context.go('/diagnostics'),
            icon: const Icon(Icons.monitor_heart_outlined),
            tooltip: 'Diagnostics',
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              refreshAuthProviders(ref);
              if (!context.mounted) {
                return;
              }
              context.go('/');
            },
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: switch (_tabIndex) {
        0 => _AndroidInspectionHomeTab(
            session: session,
            onOpenInspection: _openInspection,
          ),
        1 => _AndroidDraftsTab(
            userId: session.userId,
            canEdit: session.roleCode != 'viewer',
            onOpenInspection: _openInspection,
          ),
        _ => _AndroidResultsTab(
            userId: session.userId,
            onOpenInspection: _openInspection,
          ),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Inspect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            label: 'Drafts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_outlined),
            label: 'Results',
          ),
        ],
      ),
    );
  }

  Future<void> _openInspection(String inspectionId) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AndroidInspectionDetailScreen(inspectionId: inspectionId),
      ),
    );
    if (!mounted) {
      return;
    }
    final session = ref.read(activeSessionProvider).valueOrNull;
    if (session != null) {
      ref.invalidate(inspectionDraftsProvider(session.userId));
      ref.invalidate(inspectionResultsProvider(session.userId));
    }
    ref.invalidate(androidInspectionDiagnosticsProvider);
    ref.invalidate(inspectionDetailProvider(inspectionId));
  }
}

class _AndroidInspectionHomeTab extends ConsumerStatefulWidget {
  const _AndroidInspectionHomeTab({
    required this.session,
    required this.onOpenInspection,
  });

  final AuthSession session;
  final Future<void> Function(String inspectionId) onOpenInspection;

  @override
  ConsumerState<_AndroidInspectionHomeTab> createState() =>
      _AndroidInspectionHomeTabState();
}

class _AndroidInspectionHomeTabState
    extends ConsumerState<_AndroidInspectionHomeTab> {
  String? _selectedProductId;
  String? _selectedTargetId;
  bool _isStarting = false;
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final diagnosticsAsync = ref.watch(androidInspectionDiagnosticsProvider);
    final draftsAsync = ref.watch(inspectionDraftsProvider(widget.session.userId));
    final resultsAsync = ref.watch(inspectionResultsProvider(widget.session.userId));
    final productsAsync = ref.watch(inspectionProductsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: diagnosticsAsync.when(
              data: (diagnostics) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inspection workspace',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Local drafts: ${diagnostics.localDraftCount}'),
                  Text('Queued results: ${diagnostics.queuedResultCount}'),
                  Text('Failed sync queue: ${diagnostics.failedQueueCount}'),
                  Text('Conflicts: ${diagnostics.conflictCount}'),
                  Text('Retry-eligible queue: ${diagnostics.retryEligibleCount}'),
                  Text(
                    diagnostics.lastReferencePackageId == null
                        ? 'Reference package: not synced yet'
                        : 'Reference package: ${diagnostics.lastReferencePackageId}',
                  ),
                  if (diagnostics.lastReferenceSyncAt != null)
                    Text('Reference synced at: ${diagnostics.lastReferenceSyncAt}'),
                  if (diagnostics.lastSyncAttemptAt != null)
                    Text('Last sync attempt: ${diagnostics.lastSyncAttemptAt}'),
                  if (diagnostics.lastRetryAt != null)
                    Text('Last retry run: ${diagnostics.lastRetryAt}'),
                  if (diagnostics.lastCompletedInspectionAt != null)
                    Text(
                      'Last completed inspection: ${diagnostics.lastCompletedInspectionAt}',
                    ),
                  if (diagnostics.hasPendingSyncWork)
                    const Text('Pending sync work is waiting to be retried.'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _isSyncing ? null : _runSync,
                        icon: _isSyncing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.sync),
                        label: const Text('Sync now'),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const SizedBox(
                height: 96,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Failed to load diagnostics: $error'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (widget.session.roleCode == 'viewer')
          const Card(
            child: ListTile(
              leading: Icon(Icons.visibility_outlined),
              title: Text('Viewer access is read-only'),
              subtitle: Text(
                'This role can review inspection results but cannot create or edit drafts.',
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: productsAsync.when(
                data: (products) {
                  final effectiveProductId = _selectedProductId ??
                      (products.isNotEmpty ? products.first.productObjectId : null);
                  final targetsAsync = effectiveProductId == null
                      ? const AsyncValue<List<InspectionTargetOption>>.data([])
                      : ref.watch(inspectionTargetsProvider(effectiveProductId));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start or resume a draft',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      if (products.isEmpty)
                        const Text('No synced products are available yet.')
                      else ...[
                        DropdownButtonFormField<String>(
                          initialValue: effectiveProductId,
                          decoration: const InputDecoration(labelText: 'Product'),
                          items: [
                            for (final product in products)
                              DropdownMenuItem(
                                value: product.productObjectId,
                                child: Text(product.productName),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedProductId = value;
                              _selectedTargetId = null;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        targetsAsync.when(
                          data: (targets) {
                            final effectiveTargetId = _selectedTargetId ??
                                (targets.isNotEmpty ? targets.first.targetObjectId : null);

                            return DropdownButtonFormField<String>(
                              initialValue: effectiveTargetId,
                              decoration: const InputDecoration(
                                labelText: 'Inspection target',
                              ),
                              items: [
                                for (final target in targets)
                                  DropdownMenuItem(
                                    value: target.targetObjectId,
                                    child: Text(_targetLabel(target)),
                                  ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedTargetId = value);
                              },
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: LinearProgressIndicator(),
                          ),
                          error: (error, _) =>
                              Text('Failed to load inspection targets: $error'),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _isStarting || effectiveProductId == null
                              ? null
                              : () => _startDraft(
                                    productId: effectiveProductId,
                                    targetId: _selectedTargetId,
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
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Text('Failed to load products: $error'),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: draftsAsync.when(
              data: (drafts) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent drafts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (drafts.isEmpty)
                    const Text('No local drafts yet.')
                  else
                    for (final draft in drafts.take(3))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(draft.targetName),
                        subtitle: Text(
                          '${draft.productName} - ${draft.answeredItems}/${draft.totalItems} answered',
                        ),
                        trailing: TextButton(
                          onPressed: () => widget.onOpenInspection(draft.inspectionId),
                          child: const Text('Open'),
                        ),
                      ),
                ],
              ),
              loading: () => const SizedBox(
                height: 96,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Failed to load drafts: $error'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: resultsAsync.when(
              data: (results) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent results',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (results.isEmpty)
                    const Text('No completed inspections yet.')
                  else
                    for (final result in results.take(3))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(result.targetName),
                        subtitle: Text(
                          '${result.productName} - ${result.status} - ${result.completedAt}',
                        ),
                        trailing: TextButton(
                          onPressed: () => widget.onOpenInspection(result.inspectionId),
                          child: const Text('View'),
                        ),
                      ),
                ],
              ),
              loading: () => const SizedBox(
                height: 96,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Failed to load results: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startDraft({
    required String productId,
    required String? targetId,
  }) async {
    if (targetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an inspection target first.')),
      );
      return;
    }

      setState(() => _isStarting = true);
      try {
      final detail = await ref.read(syncServiceProvider).startInspectionDraft(
            request: InspectionStartRequest(
              userId: widget.session.userId,
              productObjectId: productId,
              targetObjectId: targetId,
            ),
          );
      ref.invalidate(androidInspectionDiagnosticsProvider);
      ref.invalidate(inspectionDraftsProvider(widget.session.userId));
      ref.invalidate(inspectionResultsProvider(widget.session.userId));
      if (productId == _selectedProductId) {
        ref.invalidate(inspectionTargetsProvider(productId));
      }
      if (!mounted) {
        return;
      }
      await widget.onOpenInspection(detail.inspection.id);
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

  Future<void> _runSync() async {
    setState(() => _isSyncing = true);
    try {
      final report = await ref.read(syncServiceProvider).runManualSync(
            platform: AppPlatform.android,
            actorUserId: widget.session.userId,
          );
      ref.invalidate(androidInspectionDiagnosticsProvider);
      ref.invalidate(syncDiagnosticsProvider);
      ref.invalidate(inspectionDraftsProvider(widget.session.userId));
      ref.invalidate(inspectionResultsProvider(widget.session.userId));
      ref.invalidate(inspectionProductsProvider);
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

  String _targetLabel(InspectionTargetOption target) {
    final indent = '  ' * target.depth;
    return '$indent${target.targetName} (${target.targetType})';
  }
}

class _AndroidDraftsTab extends ConsumerWidget {
  const _AndroidDraftsTab({
    required this.userId,
    required this.canEdit,
    required this.onOpenInspection,
  });

  final String userId;
  final bool canEdit;
  final Future<void> Function(String inspectionId) onOpenInspection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(inspectionDraftsProvider(userId));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: draftsAsync.when(
        data: (drafts) {
          if (drafts.isEmpty) {
            return const Center(child: Text('No draft inspections yet.'));
          }

          return ListView.separated(
            itemCount: drafts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    draft.status == 'in_progress'
                        ? Icons.edit_note_outlined
                        : Icons.note_alt_outlined,
                  ),
                  title: Text(draft.targetName),
                  subtitle: Text(
                    '${draft.productName}\n${draft.answeredItems}/${draft.totalItems} answered',
                  ),
                  isThreeLine: true,
                  trailing: TextButton(
                    onPressed: canEdit ? () => onOpenInspection(draft.inspectionId) : null,
                    child: Text(canEdit ? 'Open' : 'Blocked'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load drafts: $error')),
      ),
    );
  }
}

class _AndroidResultsTab extends ConsumerWidget {
  const _AndroidResultsTab({
    required this.userId,
    required this.onOpenInspection,
  });

  final String userId;
  final Future<void> Function(String inspectionId) onOpenInspection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(inspectionResultsProvider(userId));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: resultsAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return const Center(child: Text('No completed inspections yet.'));
          }

          return ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final result = results[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    result.status == 'conflict'
                        ? Icons.error_outline
                        : Icons.assignment_turned_in_outlined,
                  ),
                  title: Text(result.targetName),
                  subtitle: Text(
                    '${result.productName}\n${result.status} • ${result.syncStatus} • ${result.completedAt}',
                  ),
                  isThreeLine: true,
                  trailing: TextButton(
                    onPressed: () => onOpenInspection(result.inspectionId),
                    child: const Text('View'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load results: $error')),
      ),
    );
  }
}

class AndroidInspectionDetailScreen extends ConsumerStatefulWidget {
  const AndroidInspectionDetailScreen({
    super.key,
    required this.inspectionId,
  });

  final String inspectionId;

  @override
  ConsumerState<AndroidInspectionDetailScreen> createState() =>
      _AndroidInspectionDetailScreenState();
}

class _AndroidInspectionDetailScreenState
    extends ConsumerState<AndroidInspectionDetailScreen> {
  bool _isGeneratingPdf = false;
  bool _isCompleting = false;
  bool _isSavingSignature = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(inspectionDetailProvider(widget.inspectionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Inspection detail')),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Inspection not found.'));
          }

          final answeredCount = detail.items
              .where((item) => item.resultStatus != 'not_checked')
              .length;

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
                        detail.targetName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(detail.productName),
                      Text('Status: ${detail.inspection.status}'),
                      Text('Sync status: ${detail.inspection.syncStatus}'),
                      Text('Answered: $answeredCount/${detail.items.length}'),
                      if (detail.inspection.completedAt != null)
                        Text('Completed at: ${detail.inspection.completedAt}'),
                    ],
                  ),
                ),
              ),
              if (!detail.isEditable) ...[
                const SizedBox(height: 16),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.lock_outline),
                    title: Text('This inspection is read-only'),
                    subtitle: Text(
                      'Completed, queued, synced, or conflict inspections cannot be edited.',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _ActionSection(
                detail: detail,
                isGeneratingPdf: _isGeneratingPdf,
                isCompleting: _isCompleting,
                isSavingSignature: _isSavingSignature,
                onAddSignature: detail.isEditable ? () => _addSignature(detail) : null,
                onPreviewPdf: () => _openPreview(detail),
                onComplete: detail.isEditable ? () => _completeInspection(detail) : null,
              ),
              const SizedBox(height: 16),
              _SignatureSection(
                detail: detail,
                canEdit: detail.isEditable,
                onDeleteSignature: detail.isEditable ? _deleteSignature : null,
              ),
              const SizedBox(height: 16),
              for (final item in detail.items) ...[
                _DraftItemCard(
                  draftId: widget.inspectionId,
                  item: item,
                  enabled: detail.isEditable,
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load inspection: $error')),
      ),
    );
  }

  Future<void> _addSignature(InspectionDraftDetail detail) async {
    final session = ref.read(activeSessionProvider).valueOrNull;
    if (session == null) {
      return;
    }

    final input = await showModalBottomSheet<_SignatureCaptureResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SignatureCaptureSheet(
        initialName: session.fullName,
        initialRole: session.roleName,
      ),
    );
    if (input == null) {
      return;
    }

    setState(() => _isSavingSignature = true);
    try {
      await ref.read(inspectionsRepositoryProvider).saveSignature(
            inspectionId: detail.inspection.id,
            input: InspectionSignatureInput(
              signerUserId: session.userId,
              signerName: input.signerName,
              signerRole: input.signerRole,
              imageBytes: input.imageBytes,
            ),
          );
      await _refreshInspection(detail.inspection.id);
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingSignature = false);
      }
    }
  }

  Future<void> _deleteSignature(String signatureId) async {
    final detail = ref.read(inspectionDetailProvider(widget.inspectionId)).valueOrNull;
    if (detail == null) {
      return;
    }

    try {
      await ref.read(inspectionsRepositoryProvider).deleteSignature(
            inspectionId: detail.inspection.id,
            signatureId: signatureId,
          );
      await _refreshInspection(detail.inspection.id);
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    }
  }

  Future<void> _openPreview(InspectionDraftDetail detail) async {
    setState(() => _isGeneratingPdf = true);
    try {
      await ref.read(inspectionsRepositoryProvider).generatePdf(detail.inspection.id);
      await _refreshInspection(detail.inspection.id);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AndroidInspectionPdfPreviewScreen(
            inspectionId: detail.inspection.id,
          ),
        ),
      );
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  Future<void> _completeInspection(InspectionDraftDetail detail) async {
    final session = ref.read(activeSessionProvider).valueOrNull;
    if (session == null) {
      return;
    }

    setState(() => _isCompleting = true);
    try {
      await ref.read(syncServiceProvider).completeInspection(
            inspectionId: detail.inspection.id,
            actorUserId: session.userId,
          );
      await _refreshInspection(detail.inspection.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inspection completed and queued.')),
      );
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  Future<void> _refreshInspection(String inspectionId) async {
    ref.invalidate(inspectionDetailProvider(inspectionId));
    ref.invalidate(inspectionDraftDetailProvider(inspectionId));
    ref.invalidate(androidInspectionDiagnosticsProvider);
    ref.invalidate(syncDiagnosticsProvider);
    final session = ref.read(activeSessionProvider).valueOrNull;
    if (session != null) {
      ref.invalidate(inspectionDraftsProvider(session.userId));
      ref.invalidate(inspectionResultsProvider(session.userId));
    }
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.detail,
    required this.isGeneratingPdf,
    required this.isCompleting,
    required this.isSavingSignature,
    required this.onAddSignature,
    required this.onPreviewPdf,
    required this.onComplete,
  });

  final InspectionDraftDetail detail;
  final bool isGeneratingPdf;
  final bool isCompleting;
  final bool isSavingSignature;
  final VoidCallback? onAddSignature;
  final VoidCallback onPreviewPdf;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: onPreviewPdf,
                  icon: isGeneratingPdf
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(
                    detail.pdfInfo == null ? 'Generate PDF preview' : 'Refresh PDF preview',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: isSavingSignature ? null : onAddSignature,
                  icon: isSavingSignature
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.draw_outlined),
                  label: const Text('Add signature'),
                ),
                FilledButton.icon(
                  onPressed: isCompleting ? null : onComplete,
                  icon: isCompleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.assignment_turned_in_outlined),
                  label: const Text('Complete inspection'),
                ),
              ],
            ),
            if (detail.pdfInfo != null) ...[
              const SizedBox(height: 12),
              Text('PDF: ${detail.pdfInfo!.relativePath}'),
              Text('Checksum: ${detail.pdfInfo!.checksum}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _SignatureSection extends StatelessWidget {
  const _SignatureSection({
    required this.detail,
    required this.canEdit,
    this.onDeleteSignature,
  });

  final InspectionDraftDetail detail;
  final bool canEdit;
  final Future<void> Function(String signatureId)? onDeleteSignature;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signatures',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (detail.signatures.isEmpty)
              const Text('No signatures saved yet.')
            else
              for (final signature in detail.signatures) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 64,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(signature.imageAbsolutePath),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  ),
                  title: Text(signature.signerName),
                  subtitle: Text(
                    '${signature.signerRole}\n${signature.signedAt}',
                  ),
                  isThreeLine: true,
                  trailing: canEdit
                      ? IconButton(
                          onPressed: onDeleteSignature == null
                              ? null
                              : () => onDeleteSignature!(signature.id),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete signature',
                        )
                      : null,
                ),
                const Divider(),
              ],
          ],
        ),
      ),
    );
  }
}

class AndroidInspectionPdfPreviewScreen extends ConsumerWidget {
  const AndroidInspectionPdfPreviewScreen({
    super.key,
    required this.inspectionId,
  });

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(inspectionDetailProvider(inspectionId));

    return Scaffold(
      appBar: AppBar(title: const Text('PDF preview')),
      body: detailAsync.when(
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Inspection not found.'));
          }

          final previewText = ref
              .read(inspectionsRepositoryProvider)
              .buildReportPreviewText(detail);

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
                        'Generated local report',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Path: ${detail.pdfInfo?.absolutePath ?? 'not generated'}'),
                      Text('Checksum: ${detail.pdfInfo?.checksum ?? 'n/a'}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    previewText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load PDF preview: $error')),
      ),
    );
  }
}

class _DraftItemCard extends ConsumerStatefulWidget {
  const _DraftItemCard({
    required this.draftId,
    required this.item,
    required this.enabled,
  });

  final String draftId;
  final InspectionDraftItemView item;
  final bool enabled;

  @override
  ConsumerState<_DraftItemCard> createState() => _DraftItemCardState();
}

class _DraftItemCardState extends ConsumerState<_DraftItemCard> {
  late final TextEditingController _commentController;
  late final TextEditingController _valueController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.item.comment ?? '');
    _valueController = TextEditingController(
      text: widget.item.measuredValue ?? widget.item.comment ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant _DraftItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.comment != widget.item.comment) {
      _commentController.text = widget.item.comment ?? '';
    }
    final nextValue = widget.item.measuredValue ?? widget.item.comment ?? '';
    if (oldWidget.item.measuredValue != widget.item.measuredValue ||
        oldWidget.item.comment != widget.item.comment) {
      _valueController.text = nextValue;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.item.componentName != null) ...[
              const SizedBox(height: 4),
              Text('Component: ${widget.item.componentName}'),
            ],
            if ((widget.item.description ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(widget.item.description!),
            ],
            if ((widget.item.expectedResult ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Expected: ${widget.item.expectedResult}'),
            ],
            if (widget.item.componentImagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.item.componentImagePaths.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final imagePath = widget.item.componentImagePaths[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imagePath),
                        width: 120,
                        height: 92,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(width: 120, child: Icon(Icons.broken_image)),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            switch (widget.item.resultType) {
              'pass_fail_na' => _buildStatusSelector(
                  const ['not_checked', 'pass', 'fail', 'na'],
                ),
              'pass_fail' => _buildStatusSelector(
                  const ['not_checked', 'pass', 'fail'],
                ),
              'number' => _buildValueEditor(
                  label: 'Measured value',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  saveAsMeasuredValue: true,
                ),
              _ => _buildValueEditor(
                  label: 'Text result',
                  keyboardType: TextInputType.text,
                  saveAsMeasuredValue: false,
                ),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector(List<String> options) {
    if (!widget.enabled) {
      return _ReadonlyAnswerView(
        resultStatus: widget.item.resultStatus,
        comment: widget.item.comment,
        measuredValue: widget.item.measuredValue,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: widget.item.resultStatus,
          decoration: const InputDecoration(labelText: 'Result'),
          items: [
            for (final option in options)
              DropdownMenuItem(
                value: option,
                child: Text(_statusLabel(option)),
              ),
          ],
          onChanged: _isSaving
              ? null
              : (value) {
                  if (value == null) {
                    return;
                  }
                  _saveAnswer(resultStatus: value, comment: _commentController.text);
                },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _commentController,
          minLines: 2,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Comment',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _isSaving
                ? null
                : () => _saveAnswer(
                      resultStatus: widget.item.resultStatus,
                      comment: _commentController.text,
                    ),
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save note'),
          ),
        ),
      ],
    );
  }

  Widget _buildValueEditor({
    required String label,
    required TextInputType keyboardType,
    required bool saveAsMeasuredValue,
  }) {
    if (!widget.enabled) {
      return _ReadonlyAnswerView(
        resultStatus: widget.item.resultStatus,
        comment: widget.item.comment,
        measuredValue: widget.item.measuredValue,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _valueController,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _isSaving
                ? null
                : () => _saveAnswer(
                      resultStatus:
                          _valueController.text.trim().isEmpty ? 'not_checked' : 'pass',
                      comment: saveAsMeasuredValue ? null : _valueController.text,
                      measuredValue:
                          saveAsMeasuredValue ? _valueController.text : null,
                    ),
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save value'),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAnswer({
    required String resultStatus,
    String? comment,
    String? measuredValue,
  }) async {
    setState(() => _isSaving = true);
    try {
      await ref.read(inspectionsRepositoryProvider).saveItemAnswer(
            inspectionId: widget.draftId,
            answerId: widget.item.answerId,
            resultStatus: resultStatus,
            comment: comment,
            measuredValue: measuredValue,
          );
      ref.invalidate(inspectionDetailProvider(widget.draftId));
      ref.invalidate(inspectionDraftDetailProvider(widget.draftId));
      final session = ref.read(activeSessionProvider).valueOrNull;
      if (session != null) {
        ref.invalidate(inspectionDraftsProvider(session.userId));
        ref.invalidate(inspectionResultsProvider(session.userId));
      }
      ref.invalidate(androidInspectionDiagnosticsProvider);
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _statusLabel(String value) {
    return switch (value) {
      'pass' => 'Pass',
      'fail' => 'Fail',
      'na' => 'N/A',
      _ => 'Not checked',
    };
  }
}

class _ReadonlyAnswerView extends StatelessWidget {
  const _ReadonlyAnswerView({
    required this.resultStatus,
    this.comment,
    this.measuredValue,
  });

  final String resultStatus;
  final String? comment;
  final String? measuredValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Result: $resultStatus'),
        if ((measuredValue ?? '').isNotEmpty) Text('Value: $measuredValue'),
        if ((comment ?? '').isNotEmpty) Text('Comment: $comment'),
      ],
    );
  }
}

class SignatureCaptureSheet extends StatefulWidget {
  const SignatureCaptureSheet({
    super.key,
    required this.initialName,
    required this.initialRole,
  });

  final String initialName;
  final String initialRole;

  @override
  State<SignatureCaptureSheet> createState() => _SignatureCaptureSheetState();
}

class _SignatureCaptureSheetState extends State<SignatureCaptureSheet> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final GlobalKey<SignaturePadState> _signatureKey = GlobalKey<SignaturePadState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _roleController.text = widget.initialRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add signature',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Signer name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Signer role'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: SignaturePad(key: _signatureKey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => _signatureKey.currentState?.clear(),
                    child: const Text('Clear'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save signature'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final imageBytes = await _signatureKey.currentState?.exportPngBytes();
    if (!mounted) {
      return;
    }
    if (imageBytes == null || imageBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draw a signature before saving.')),
      );
      return;
    }

    Navigator.of(context).pop(
      _SignatureCaptureResult(
        signerName: _nameController.text.trim(),
        signerRole: _roleController.text.trim(),
        imageBytes: imageBytes,
      ),
    );
  }
}

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => SignaturePadState();
}

class SignaturePadState extends State<SignaturePad> {
  final List<List<Offset>> _strokes = [];

  bool get hasStrokes => _strokes.any((stroke) => stroke.isNotEmpty);

  void clear() {
    setState(_strokes.clear);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _strokes.add([details.localPosition]);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            if (_strokes.isEmpty) {
              _strokes.add([details.localPosition]);
            } else {
              _strokes.last.add(details.localPosition);
            }
          });
        },
        child: CustomPaint(
          painter: _SignaturePainter(_strokes),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Future<Uint8List?> exportPngBytes() async {
    if (!hasStrokes) {
      return null;
    }

    final renderObject = context.findRenderObject() as RenderBox?;
    final size = renderObject?.size ?? const Size(480, 220);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );
    _SignaturePainter(_strokes).paint(canvas, size);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.ceil(), size.height.ceil());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) {
          canvas.drawCircle(stroke.first, 1.5, paint..style = PaintingStyle.fill);
          paint.style = PaintingStyle.stroke;
        }
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

class _SignatureCaptureResult {
  const _SignatureCaptureResult({
    required this.signerName,
    required this.signerRole,
    required this.imageBytes,
  });

  final String signerName;
  final String signerRole;
  final Uint8List imageBytes;
}
