import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inspections/data/inspection_repositories.dart';

class InspectionHistoryScreen extends ConsumerStatefulWidget {
  const InspectionHistoryScreen({super.key});

  @override
  ConsumerState<InspectionHistoryScreen> createState() =>
      _InspectionHistoryScreenState();
}

class _InspectionHistoryScreenState
    extends ConsumerState<InspectionHistoryScreen> {
  String? _selectedInspectionId;

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(allInspectionResultsProvider);

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              'No completed inspections have been recorded yet.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final effectiveSelectedId =
            results.any(
              (result) => result.inspectionId == _selectedInspectionId,
            )
            ? _selectedInspectionId!
            : results.first.inspectionId;
        final selected = results.firstWhere(
          (result) => result.inspectionId == effectiveSelectedId,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 380,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Inspection history',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${results.length} completed inspection(s)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Refresh',
                          onPressed: () {
                            ref.invalidate(allInspectionResultsProvider);
                            ref.invalidate(
                              inspectionDetailProvider(effectiveSelectedId),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final result = results[index];
                        final selectedTile =
                            result.inspectionId == effectiveSelectedId;
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: selectedTile ? 2 : 0,
                          child: ListTile(
                            selected: selectedTile,
                            leading: const Icon(
                              Icons.assignment_turned_in_outlined,
                            ),
                            title: Text(result.targetName),
                            subtitle: Text(
                              [
                                result.productName,
                                result.userName ?? result.userId,
                                '${result.status}/${result.syncStatus}',
                                'signatures: ${result.signatureCount}',
                                'pdf: ${result.hasPdf ? 'yes' : 'no'}',
                              ].join(' • '),
                            ),
                            trailing: SizedBox(
                              width: 88,
                              child: Text(
                                result.completedAt,
                                textAlign: TextAlign.end,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            onTap: () => setState(
                              () => _selectedInspectionId = result.inspectionId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _InspectionResultDetailPane(summary: selected)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load inspection history: $error')),
    );
  }
}

class _InspectionResultDetailPane extends ConsumerWidget {
  const _InspectionResultDetailPane({required this.summary});

  final InspectionResultSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      inspectionDetailProvider(summary.inspectionId),
    );

    return detailAsync.when(
      data: (detail) {
        if (detail == null) {
          return const Center(
            child: Text('Inspection details are no longer available.'),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              detail.targetName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              detail.productName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _DetailCard(
              title: 'Inspection summary',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Inspection ID',
                    value: detail.inspection.id,
                  ),
                  _DetailRow(
                    label: 'Inspector',
                    value: summary.userName ?? summary.userId,
                  ),
                  _DetailRow(label: 'Status', value: detail.inspection.status),
                  _DetailRow(
                    label: 'Sync status',
                    value: detail.inspection.syncStatus,
                  ),
                  _DetailRow(
                    label: 'Started at',
                    value: detail.inspection.startedAt,
                  ),
                  _DetailRow(
                    label: 'Completed at',
                    value: detail.inspection.completedAt ?? 'n/a',
                  ),
                  _DetailRow(
                    label: 'Signatures',
                    value: '${detail.signatures.length}',
                  ),
                  _DetailRow(
                    label: 'PDF report',
                    value: detail.pdfInfo?.relativePath ?? 'not generated',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DetailCard(
              title: 'Signatures',
              child: detail.signatures.isEmpty
                  ? const Text('No signatures recorded.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final signature in detail.signatures)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${signature.signerName} (${signature.signerRole})',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                SelectableText(signature.imageRelativePath),
                                const SizedBox(height: 2),
                                Text(
                                  'Signed at: ${signature.signedAt}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            _DetailCard(
              title: 'Checklist result',
              child: Column(
                children: [
                  for (final item in detail.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ChecklistItemTile(item: item),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load inspection details: $error')),
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  const _ChecklistItemTile({required this.item});

  final InspectionDraftItemView item;

  @override
  Widget build(BuildContext context) {
    final details = <String>[
      'type: ${item.resultType}',
      'result: ${item.resultStatus}',
      if ((item.componentName ?? '').isNotEmpty)
        'component: ${item.componentName}',
      if ((item.expectedResult ?? '').isNotEmpty)
        'expected: ${item.expectedResult}',
      if ((item.measuredValue ?? '').isNotEmpty)
        'measured: ${item.measuredValue}',
      if ((item.comment ?? '').isNotEmpty) 'comment: ${item.comment}',
      if (item.componentImagePaths.isNotEmpty)
        'images: ${item.componentImagePaths.length}',
    ];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        item.resultStatus == 'pass'
            ? Icons.check_circle_outline
            : item.resultStatus == 'fail'
            ? Icons.error_outline
            : Icons.radio_button_unchecked,
      ),
      title: Text(item.title),
      subtitle: Text(details.join('\n')),
      isThreeLine: true,
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 2),
          SelectableText(value),
        ],
      ),
    );
  }
}
