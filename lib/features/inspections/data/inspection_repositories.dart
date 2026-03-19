import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/config/app_constants.dart';
import '../../../core/storage/app_paths.dart';
import '../../../core/utils/checksum.dart';
import '../../../data/sqlite/app_database.dart';
import '../../../data/sqlite/database_provider.dart';
import '../../../data/sqlite/repository_support.dart';
import '../../../data/storage/app_paths_provider.dart';
import 'inspection_report_document.dart';

class InspectionProductOption {
  const InspectionProductOption({
    required this.productObjectId,
    required this.productName,
  });

  final String productObjectId;
  final String productName;
}

class InspectionTargetOption {
  const InspectionTargetOption({
    required this.productObjectId,
    required this.productName,
    required this.targetObjectId,
    required this.targetName,
    required this.targetType,
    required this.depth,
  });

  final String productObjectId;
  final String productName;
  final String targetObjectId;
  final String targetName;
  final String targetType;
  final int depth;
}

class InspectionDraftSummary {
  const InspectionDraftSummary({
    required this.inspectionId,
    required this.productObjectId,
    required this.productName,
    required this.targetObjectId,
    required this.targetName,
    required this.status,
    required this.updatedAt,
    required this.answeredItems,
    required this.totalItems,
  });

  final String inspectionId;
  final String productObjectId;
  final String productName;
  final String targetObjectId;
  final String targetName;
  final String status;
  final String updatedAt;
  final int answeredItems;
  final int totalItems;
}

class InspectionResultSummary {
  const InspectionResultSummary({
    required this.inspectionId,
    required this.productObjectId,
    required this.productName,
    required this.targetObjectId,
    required this.targetName,
    required this.status,
    required this.syncStatus,
    required this.completedAt,
    required this.signatureCount,
    required this.hasPdf,
  });

  final String inspectionId;
  final String productObjectId;
  final String productName;
  final String targetObjectId;
  final String targetName;
  final String status;
  final String syncStatus;
  final String completedAt;
  final int signatureCount;
  final bool hasPdf;
}

class InspectionDraftItemView {
  const InspectionDraftItemView({
    required this.answerId,
    required this.checklistItemId,
    required this.title,
    required this.resultType,
    required this.isRequired,
    required this.sortOrder,
    required this.resultStatus,
    required this.componentId,
    required this.componentImagePaths,
    this.componentName,
    this.description,
    this.expectedResult,
    this.comment,
    this.measuredValue,
  });

  final String answerId;
  final String checklistItemId;
  final String title;
  final String resultType;
  final bool isRequired;
  final int sortOrder;
  final String resultStatus;
  final String? componentId;
  final String? componentName;
  final String? description;
  final String? expectedResult;
  final String? comment;
  final String? measuredValue;
  final List<String> componentImagePaths;
}

class InspectionSignatureInput {
  const InspectionSignatureInput({
    required this.signerName,
    required this.signerRole,
    required this.imageBytes,
    this.signerUserId,
  });

  final String signerName;
  final String signerRole;
  final List<int> imageBytes;
  final String? signerUserId;
}

class InspectionSignatureView {
  const InspectionSignatureView({
    required this.id,
    required this.signerName,
    required this.signerRole,
    required this.imageRelativePath,
    required this.imageAbsolutePath,
    required this.checksum,
    required this.signedAt,
    this.signerUserId,
  });

  final String id;
  final String? signerUserId;
  final String signerName;
  final String signerRole;
  final String imageRelativePath;
  final String imageAbsolutePath;
  final String checksum;
  final String signedAt;
}

class InspectionPdfInfo {
  const InspectionPdfInfo({
    required this.relativePath,
    required this.absolutePath,
    required this.checksum,
  });

  final String relativePath;
  final String absolutePath;
  final String checksum;
}

class InspectionDraftDetail {
  const InspectionDraftDetail({
    required this.inspection,
    required this.productName,
    required this.targetName,
    required this.items,
    required this.signatures,
    required this.isEditable,
    this.pdfInfo,
  });

  final Inspection inspection;
  final String productName;
  final String targetName;
  final List<InspectionDraftItemView> items;
  final List<InspectionSignatureView> signatures;
  final bool isEditable;
  final InspectionPdfInfo? pdfInfo;
}

class InspectionCompletionStatus {
  const InspectionCompletionStatus({
    required this.inspectionId,
    required this.status,
    required this.syncStatus,
    required this.completedAt,
    required this.queueRecordId,
    required this.pdfInfo,
  });

  final String inspectionId;
  final String status;
  final String syncStatus;
  final String completedAt;
  final String queueRecordId;
  final InspectionPdfInfo pdfInfo;
}

class InspectionStartRequest {
  const InspectionStartRequest({
    required this.userId,
    required this.productObjectId,
    required this.targetObjectId,
  });

  final String userId;
  final String productObjectId;
  final String targetObjectId;
}

class AndroidInspectionDiagnostics {
  const AndroidInspectionDiagnostics({
    required this.localDraftCount,
    required this.queuedResultCount,
    required this.failedQueueCount,
    required this.conflictCount,
    required this.lastReferencePackageId,
    required this.lastReferenceSyncAt,
    required this.lastSyncAttemptAt,
    required this.lastCompletedInspectionAt,
  });

  final int localDraftCount;
  final int queuedResultCount;
  final int failedQueueCount;
  final int conflictCount;
  final String? lastReferencePackageId;
  final String? lastReferenceSyncAt;
  final String? lastSyncAttemptAt;
  final String? lastCompletedInspectionAt;

  bool get hasPendingSyncWork => queuedResultCount > 0 || failedQueueCount > 0;
}

class _ResolvedChecklistItem {
  const _ResolvedChecklistItem({
    required this.item,
    required this.priority,
  });

  final ChecklistItem item;
  final int priority;
}

final inspectionsRepositoryProvider = Provider<InspectionsRepository>(
  (ref) => InspectionsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(appPathsProvider),
  ),
);

final inspectionProductsProvider = FutureProvider<List<InspectionProductOption>>(
  (ref) => ref.watch(inspectionsRepositoryProvider).listProducts(),
);

final inspectionTargetsProvider =
    FutureProvider.family<List<InspectionTargetOption>, String>((ref, productId) {
      return ref.watch(inspectionsRepositoryProvider).listSelectableInspectionTargets(
            productId,
          );
    });

final inspectionDraftsProvider =
    FutureProvider.family<List<InspectionDraftSummary>, String>((ref, userId) {
      return ref.watch(inspectionsRepositoryProvider).listDrafts(userId: userId);
    });

final inspectionResultsProvider =
    FutureProvider.family<List<InspectionResultSummary>, String>((ref, userId) {
      return ref.watch(inspectionsRepositoryProvider).listResults(userId: userId);
    });

final inspectionDetailProvider =
    FutureProvider.family<InspectionDraftDetail?, String>((ref, inspectionId) {
      return ref.watch(inspectionsRepositoryProvider).loadInspection(inspectionId);
    });

final inspectionDraftDetailProvider =
    FutureProvider.family<InspectionDraftDetail?, String>((ref, inspectionId) {
      return ref.watch(inspectionsRepositoryProvider).loadInspection(inspectionId);
    });

final androidInspectionDiagnosticsProvider =
    FutureProvider<AndroidInspectionDiagnostics>((ref) {
      return ref.watch(inspectionsRepositoryProvider).loadDiagnostics();
    });

class InspectionsRepository {
  InspectionsRepository(this._db, this._paths);

  final AppDatabase _db;
  final AppPaths _paths;

  Future<List<InspectionProductOption>> listProducts() async {
    final products = await (_db.select(_db.catalogObjects)
          ..where(
            (tbl) =>
                tbl.isDeleted.equals(false) &
                tbl.isActive.equals(true) &
                tbl.type.equals('product'),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();

    return products
        .map(
          (product) => InspectionProductOption(
            productObjectId: product.id,
            productName: product.name,
          ),
        )
        .toList(growable: false);
  }

  Future<List<InspectionTargetOption>> listSelectableInspectionTargets(
    String productId,
  ) async {
    if (productId.trim().isEmpty) {
      return const [];
    }

    final objects = await _listActiveObjects();
    final byId = {for (final object in objects) object.id: object};
    final product = byId[productId];
    if (product == null || product.type != 'product') {
      return const [];
    }

    final childrenByParent = <String?, List<CatalogObject>>{};
    for (final object in objects) {
      childrenByParent.putIfAbsent(object.parentId, () => []).add(object);
    }
    for (final children in childrenByParent.values) {
      children.sort((left, right) {
        final order = left.sortOrder.compareTo(right.sortOrder);
        if (order != 0) {
          return order;
        }
        return left.name.compareTo(right.name);
      });
    }

    final targets = <InspectionTargetOption>[];

    void walk(CatalogObject current, int depth) {
      targets.add(
        InspectionTargetOption(
          productObjectId: product.id,
          productName: product.name,
          targetObjectId: current.id,
          targetName: current.name,
          targetType: current.type,
          depth: depth,
        ),
      );

      for (final child in childrenByParent[current.id] ?? const <CatalogObject>[]) {
        walk(child, depth + 1);
      }
    }

    walk(product, 0);
    return targets;
  }

  Future<List<InspectionDraftSummary>> listDrafts({
    required String userId,
  }) async {
    final inspections = await (_db.select(_db.inspections)
          ..where(
            (tbl) =>
                tbl.userId.equals(userId) &
                (tbl.status.equals('draft') | tbl.status.equals('in_progress')),
          )
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .get();

    if (inspections.isEmpty) {
      return const [];
    }

    final objectNames = await _loadObjectNames();
    final answersByInspection = await _loadAnswersByInspection(
      inspections.map((item) => item.id),
    );

    return inspections
        .map((inspection) {
          final items = answersByInspection[inspection.id] ?? const <InspectionItem>[];
          final answeredCount = items
              .where((item) => item.resultStatus != 'not_checked')
              .length;
          return InspectionDraftSummary(
            inspectionId: inspection.id,
            productObjectId: inspection.productObjectId,
            productName:
                objectNames[inspection.productObjectId] ?? inspection.productObjectId,
            targetObjectId: inspection.targetObjectId,
            targetName:
                objectNames[inspection.targetObjectId] ?? inspection.targetObjectId,
            status: inspection.status,
            updatedAt: inspection.updatedAt,
            answeredItems: answeredCount,
            totalItems: items.length,
          );
        })
        .toList(growable: false);
  }

  Future<List<InspectionResultSummary>> listResults({
    required String userId,
  }) async {
    final inspections = await (_db.select(_db.inspections)
          ..where(
            (tbl) =>
                tbl.userId.equals(userId) &
                (tbl.status.equals('completed') |
                    tbl.status.equals('queued') |
                    tbl.status.equals('synced') |
                    tbl.status.equals('conflict')),
          )
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.completedAt),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .get();

    if (inspections.isEmpty) {
      return const [];
    }

    final objectNames = await _loadObjectNames();
    final signatures = await (_db.select(_db.inspectionSignatures)
          ..where((tbl) => tbl.inspectionId.isIn(inspections.map((item) => item.id))))
        .get();
    final signatureCounts = <String, int>{};
    for (final signature in signatures) {
      signatureCounts.update(
        signature.inspectionId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return inspections
        .map(
          (inspection) => InspectionResultSummary(
            inspectionId: inspection.id,
            productObjectId: inspection.productObjectId,
            productName:
                objectNames[inspection.productObjectId] ?? inspection.productObjectId,
            targetObjectId: inspection.targetObjectId,
            targetName:
                objectNames[inspection.targetObjectId] ?? inspection.targetObjectId,
            status: inspection.status,
            syncStatus: inspection.syncStatus,
            completedAt: inspection.completedAt ?? inspection.updatedAt,
            signatureCount: signatureCounts[inspection.id] ?? 0,
            hasPdf: nullableField(inspection.pdfLocalPath) != null,
          ),
        )
        .toList(growable: false);
  }

  Future<InspectionDraftDetail?> loadInspection(String inspectionId) async {
    final inspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();
    if (inspection == null) {
      return null;
    }

    final answers = await (_db.select(_db.inspectionItems)
          ..where((tbl) => tbl.inspectionId.equals(inspectionId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.id),
          ]))
        .get();
    final checklistItems = await (_db.select(_db.checklistItems)
          ..where(
            (tbl) => tbl.id.isIn(answers.map((item) => item.checklistItemId)),
          ))
        .get();
    final checklistItemsById = {
      for (final item in checklistItems) item.id: item,
    };
    final components = await (_db.select(_db.components)
          ..where(
            (tbl) => tbl.id.isIn(
              answers.map((item) => item.componentId).whereType<String>(),
            ),
          ))
        .get();
    final componentsById = {for (final item in components) item.id: item};
    final componentImagePaths = await _loadComponentImagePaths(
      components.map((component) => component.id),
    );
    final objectNames = await _loadObjectNames();
    final signatures = await _loadSignatures(inspection.id);

    return InspectionDraftDetail(
      inspection: inspection,
      productName:
          objectNames[inspection.productObjectId] ?? inspection.productObjectId,
      targetName:
          objectNames[inspection.targetObjectId] ?? inspection.targetObjectId,
      signatures: signatures,
      isEditable: _isEditableStatus(inspection.status),
      pdfInfo: _loadPdfInfo(inspection),
      items: answers
          .map((answer) {
            final checklistItem = checklistItemsById[answer.checklistItemId];
            if (checklistItem == null) {
              return null;
            }

            final component = answer.componentId == null
                ? null
                : componentsById[answer.componentId!];
            return InspectionDraftItemView(
              answerId: answer.id,
              checklistItemId: answer.checklistItemId,
              title: checklistItem.title,
              description: checklistItem.description,
              expectedResult: checklistItem.expectedResult,
              resultType: checklistItem.resultType,
              isRequired: checklistItem.isRequired,
              sortOrder: answer.sortOrder,
              resultStatus: answer.resultStatus,
              componentId: answer.componentId,
              componentName: component?.name,
              componentImagePaths:
                  component == null ? const [] : componentImagePaths[component.id] ?? const [],
              comment: answer.comment,
              measuredValue: answer.measuredValue,
            );
          })
          .whereType<InspectionDraftItemView>()
          .toList(growable: false),
    );
  }

  Future<InspectionDraftDetail> startOrResumeDraft(
    InspectionStartRequest request,
  ) async {
    final objects = await _listActiveObjects();
    final objectsById = {for (final object in objects) object.id: object};
    final product = objectsById[request.productObjectId];
    final target = objectsById[request.targetObjectId];
    if (product == null || product.type != 'product') {
      throw StateError('Selected product is unavailable.');
    }
    if (target == null) {
      throw StateError('Selected inspection target is unavailable.');
    }
    if (!_belongsToProduct(
      targetId: target.id,
      productId: product.id,
      objectsById: objectsById,
    )) {
      throw StateError('Selected target does not belong to the selected product.');
    }

    final existingDraft = await (_db.select(_db.inspections)
          ..where(
            (tbl) =>
                tbl.userId.equals(request.userId) &
                tbl.targetObjectId.equals(request.targetObjectId) &
                (tbl.status.equals('draft') | tbl.status.equals('in_progress')),
          )
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
    if (existingDraft != null) {
      final detail = await loadInspection(existingDraft.id);
      if (detail != null) {
        return detail;
      }
    }

    final resolvedItems = await _resolveChecklistItems(
      productObjectId: product.id,
      targetObjectId: target.id,
    );
    if (resolvedItems.isEmpty) {
      throw StateError('No checklist is assigned to the selected target.');
    }

    final now = nowIso();
    final inspectionId = generateId('inspection');
    final device = await _db.select(_db.deviceInfo).getSingleOrNull();
    final syncState = await (_db.select(_db.syncState)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ])
          ..limit(1))
        .getSingleOrNull();

    await _db.transaction(() async {
      await _db.into(_db.inspections).insert(
            InspectionsCompanion.insert(
              id: inspectionId,
              deviceId: device?.id ?? AppConstants.defaultDeviceId,
              userId: request.userId,
              productObjectId: product.id,
              targetObjectId: target.id,
              startedAt: now,
              status: 'draft',
              syncStatus: 'local_only',
              sourceReferencePackageId: driftValue(syncState?.lastReferencePackageId),
              sourceReferenceVersion: const Value.absent(),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await _db.batch((batch) {
        batch.insertAll(
          _db.inspectionItems,
          [
            for (var index = 0; index < resolvedItems.length; index++)
              InspectionItemsCompanion.insert(
                id: generateId('inspection-item'),
                inspectionId: inspectionId,
                checklistItemId: resolvedItems[index].item.id,
                componentId: driftValue(resolvedItems[index].item.componentId),
                resultStatus: const Value('not_checked'),
                sortOrder: Value(index),
                createdAt: now,
                updatedAt: now,
              ),
          ],
        );
      });
    });

    await recordAudit(
      _db,
      actionType: 'inspection.start',
      resultStatus: 'success',
      userId: request.userId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Local inspection draft created',
      payload: {
        'product_object_id': product.id,
        'target_object_id': target.id,
        'items': resolvedItems.length,
      },
    );

    return (await loadInspection(inspectionId))!;
  }

  Future<void> saveItemAnswer({
    required String inspectionId,
    required String answerId,
    required String resultStatus,
    String? comment,
    String? measuredValue,
  }) async {
    final inspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();
    if (inspection == null) {
      throw StateError('Inspection draft not found.');
    }
    _ensureEditableInspection(inspection);

    final answer = await (_db.select(_db.inspectionItems)
          ..where((tbl) => tbl.id.equals(answerId)))
        .getSingleOrNull();
    if (answer == null || answer.inspectionId != inspectionId) {
      throw StateError('Inspection answer not found.');
    }

    final now = nowIso();
    final normalizedResult = resultStatus.trim().isEmpty
        ? 'not_checked'
        : resultStatus.trim();
    final normalizedComment = nullableField(comment);
    final normalizedMeasuredValue = nullableField(measuredValue);
    final nextStatus =
        normalizedResult == 'not_checked' ? inspection.status : 'in_progress';

    await _db.transaction(() async {
      await (_db.update(_db.inspectionItems)..where((tbl) => tbl.id.equals(answerId)))
          .write(
        InspectionItemsCompanion(
          resultStatus: Value(normalizedResult),
          comment: Value(normalizedComment),
          measuredValue: Value(normalizedMeasuredValue),
          updatedAt: Value(now),
        ),
      );
      await (_db.update(_db.inspections)..where((tbl) => tbl.id.equals(inspectionId)))
          .write(
        InspectionsCompanion(
          status: Value(nextStatus),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<InspectionSignatureView> saveSignature({
    required String inspectionId,
    required InspectionSignatureInput input,
  }) async {
    final inspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();
    if (inspection == null) {
      throw StateError('Inspection draft not found.');
    }
    _ensureEditableInspection(inspection);

    final signerName = nullableField(input.signerName);
    final signerRole = nullableField(input.signerRole);
    if (signerName == null || signerRole == null) {
      throw StateError('Signer name and role are required.');
    }
    if (input.imageBytes.isEmpty) {
      throw StateError('Signature image is empty.');
    }

    final targetDir = Directory(
      _paths.resolveRelativePath('media/signatures/$inspectionId'),
    );
    await targetDir.create(recursive: true);

    final fileName = 'signature_${DateTime.now().toUtc().microsecondsSinceEpoch}.png';
    final absolutePath = p.join(targetDir.path, fileName);
    final file = File(absolutePath);
    await file.writeAsBytes(input.imageBytes, flush: true);

    final checksum = await checksumFile(file);
    final relativePath = _paths.signatureRelativePath(inspectionId, fileName);
    final now = nowIso();
    final signatureId = generateId('inspection-signature');

    await _db.into(_db.inspectionSignatures).insert(
          InspectionSignaturesCompanion.insert(
            id: signatureId,
            inspectionId: inspectionId,
            signerUserId: driftValue(input.signerUserId),
            signerName: signerName,
            signerRole: signerRole,
            imageLocalPath: relativePath,
            checksum: checksum,
            signedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

    await (_db.update(_db.inspections)..where((tbl) => tbl.id.equals(inspectionId)))
        .write(InspectionsCompanion(updatedAt: Value(now)));

    await recordAudit(
      _db,
      actionType: 'inspection.signature.add',
      resultStatus: 'success',
      userId: input.signerUserId ?? inspection.userId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Inspection signature saved locally',
      payload: {
        'signer_name': signerName,
        'signer_role': signerRole,
      },
    );

    return InspectionSignatureView(
      id: signatureId,
      signerUserId: input.signerUserId,
      signerName: signerName,
      signerRole: signerRole,
      imageRelativePath: relativePath,
      imageAbsolutePath: absolutePath,
      checksum: checksum,
      signedAt: now,
    );
  }

  Future<void> deleteSignature({
    required String inspectionId,
    required String signatureId,
  }) async {
    final inspection = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.id.equals(inspectionId)))
        .getSingleOrNull();
    if (inspection == null) {
      throw StateError('Inspection draft not found.');
    }
    _ensureEditableInspection(inspection);

    final signature = await (_db.select(_db.inspectionSignatures)
          ..where((tbl) => tbl.id.equals(signatureId)))
        .getSingleOrNull();
    if (signature == null || signature.inspectionId != inspectionId) {
      throw StateError('Signature not found.');
    }

    final absolutePath = _paths.resolveRelativePath(signature.imageLocalPath);
    final file = File(absolutePath);
    if (await file.exists()) {
      await file.delete();
    }

    await (_db.delete(_db.inspectionSignatures)..where((tbl) => tbl.id.equals(signatureId)))
        .go();
    await (_db.update(_db.inspections)..where((tbl) => tbl.id.equals(inspectionId)))
        .write(InspectionsCompanion(updatedAt: Value(nowIso())));

    await recordAudit(
      _db,
      actionType: 'inspection.signature.delete',
      resultStatus: 'success',
      userId: inspection.userId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Inspection signature deleted',
      payload: {'signature_id': signatureId},
    );
  }

  Future<InspectionPdfInfo> generatePdf(String inspectionId) async {
    final detail = await loadInspection(inspectionId);
    if (detail == null) {
      throw StateError('Inspection not found.');
    }

    final input = _buildReportDocumentInput(detail);
    final targetDir = Directory(_paths.resolveRelativePath('media/reports/$inspectionId'));
    await targetDir.create(recursive: true);
    final fileName = 'inspection_report.pdf';
    final file = File(p.join(targetDir.path, fileName));
    await file.writeAsBytes(buildInspectionPdfBytes(input), flush: true);
    final checksum = await checksumFile(file);
    final relativePath = _paths.reportRelativePath(inspectionId, fileName);
    final now = nowIso();

    await (_db.update(_db.inspections)..where((tbl) => tbl.id.equals(inspectionId))).write(
      InspectionsCompanion(
        pdfLocalPath: Value(relativePath),
        pdfChecksum: Value(checksum),
        updatedAt: Value(now),
      ),
    );
    await _upsertInspectionPdfFile(
      inspectionId: inspectionId,
      fileName: fileName,
      relativePath: relativePath,
      checksum: checksum,
      updatedAt: now,
    );

    await recordAudit(
      _db,
      actionType: 'inspection.pdf.generate',
      resultStatus: 'success',
      userId: detail.inspection.userId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Inspection PDF generated locally',
    );

    return InspectionPdfInfo(
      relativePath: relativePath,
      absolutePath: file.path,
      checksum: checksum,
    );
  }

  Future<InspectionCompletionStatus> completeInspection({
    required String inspectionId,
    required String actorUserId,
  }) async {
    final detail = await loadInspection(inspectionId);
    if (detail == null) {
      throw StateError('Inspection not found.');
    }
    _ensureEditableInspection(detail.inspection);
    _validateCompletion(detail);

    final pdfInfo = detail.pdfInfo ?? await generatePdf(inspectionId);
    final packageDir = await _exportResultPackage(detail, pdfInfo);
    final completedAt = nowIso();
    final queueRecordId = await _enqueueResultPackage(
      inspectionId: inspectionId,
      packageDirectory: packageDir,
      updatedAt: completedAt,
    );

    await (_db.update(_db.inspections)..where((tbl) => tbl.id.equals(inspectionId))).write(
      InspectionsCompanion(
        completedAt: Value(completedAt),
        status: const Value('queued'),
        syncStatus: const Value('queued'),
        updatedAt: Value(completedAt),
      ),
    );

    await recordAudit(
      _db,
      actionType: 'inspection.complete',
      resultStatus: 'success',
      userId: actorUserId,
      entityType: 'inspection',
      entityId: inspectionId,
      message: 'Inspection completed and queued for sync',
      payload: {
        'queue_record_id': queueRecordId,
        'package_path': _paths.relativeToRoot(packageDir.path),
      },
    );

    return InspectionCompletionStatus(
      inspectionId: inspectionId,
      status: 'queued',
      syncStatus: 'queued',
      completedAt: completedAt,
      queueRecordId: queueRecordId,
      pdfInfo: pdfInfo,
    );
  }

  String buildReportPreviewText(InspectionDraftDetail detail) {
    return buildInspectionReportPreviewText(_buildReportDocumentInput(detail));
  }

  Future<AndroidInspectionDiagnostics> loadDiagnostics() async {
    final draftCountExpression = _db.inspections.id.count();
    final draftCount = await (_db.selectOnly(_db.inspections)
          ..addColumns([draftCountExpression])
          ..where(
            _db.inspections.status.equals('draft') |
                _db.inspections.status.equals('in_progress'),
          ))
        .getSingle();
    final queuedCountExpression = _db.inspections.id.count();
    final queuedCount = await (_db.selectOnly(_db.inspections)
          ..addColumns([queuedCountExpression])
          ..where(
            _db.inspections.status.equals('queued') |
                _db.inspections.syncStatus.equals('queued'),
          ))
        .getSingle();
    final failedQueueExpression = _db.syncQueue.id.count();
    final failedQueue = await (_db.selectOnly(_db.syncQueue)
          ..addColumns([failedQueueExpression])
          ..where(_db.syncQueue.status.equals('failed')))
        .getSingle();
    final conflictExpression = _db.inspections.id.count();
    final conflicts = await (_db.selectOnly(_db.inspections)
          ..addColumns([conflictExpression])
          ..where(
            _db.inspections.status.equals('conflict') |
                _db.inspections.syncStatus.equals('conflict'),
          ))
        .getSingle();
    final lastCompleted = await (_db.select(_db.inspections)
          ..where((tbl) => tbl.completedAt.isNotNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)])
          ..limit(1))
        .getSingleOrNull();
    final syncState = await (_db.select(_db.syncState)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ])
          ..limit(1))
        .getSingleOrNull();

    return AndroidInspectionDiagnostics(
      localDraftCount: draftCount.read(draftCountExpression) ?? 0,
      queuedResultCount: queuedCount.read(queuedCountExpression) ?? 0,
      failedQueueCount: failedQueue.read(failedQueueExpression) ?? 0,
      conflictCount: conflicts.read(conflictExpression) ?? 0,
      lastReferencePackageId: syncState?.lastReferencePackageId,
      lastReferenceSyncAt: syncState?.lastReferenceSyncAt,
      lastSyncAttemptAt: syncState?.updatedAt,
      lastCompletedInspectionAt: lastCompleted?.completedAt,
    );
  }

  Future<List<_ResolvedChecklistItem>> _resolveChecklistItems({
    required String productObjectId,
    required String targetObjectId,
  }) async {
    final target = await (_db.select(_db.catalogObjects)
          ..where(
            (tbl) =>
                tbl.id.equals(targetObjectId) &
                tbl.isDeleted.equals(false) &
                tbl.isActive.equals(true),
          ))
        .getSingleOrNull();
    if (target == null) {
      return const [];
    }

    final checklists = await (_db.select(_db.checklists)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true)))
        .get();
    final activeChecklistIds = checklists.map((item) => item.id).toSet();
    final bindings = await (_db.select(_db.checklistBindings)
          ..where(
            (tbl) =>
                tbl.isDeleted.equals(false) &
                tbl.checklistId.isIn(activeChecklistIds),
          ))
        .get();

    final checklistPriorities = <String, int>{};
    for (final binding in bindings) {
      final isApplicable = switch (binding.targetType) {
        'object' => binding.targetId == targetObjectId,
        'object_type' => binding.targetObjectType == target.type,
        'product' => binding.targetId == productObjectId,
        _ => false,
      };
      if (!isApplicable) {
        continue;
      }

      final currentPriority = checklistPriorities[binding.checklistId];
      if (currentPriority == null || binding.priority < currentPriority) {
        checklistPriorities[binding.checklistId] = binding.priority;
      }
    }

    if (checklistPriorities.isEmpty) {
      return const [];
    }

    final items = await (_db.select(_db.checklistItems)
          ..where(
            (tbl) =>
                tbl.isDeleted.equals(false) &
                tbl.checklistId.isIn(checklistPriorities.keys),
          ))
        .get();

    final resolved = items
        .map(
          (item) => _ResolvedChecklistItem(
            item: item,
            priority: checklistPriorities[item.checklistId] ?? 0,
          ),
        )
        .toList(growable: false);
    resolved.sort((left, right) {
      final priority = left.priority.compareTo(right.priority);
      if (priority != 0) {
        return priority;
      }
      final order = left.item.sortOrder.compareTo(right.item.sortOrder);
      if (order != 0) {
        return order;
      }
      return left.item.title.compareTo(right.item.title);
    });

    return resolved;
  }

  Future<List<CatalogObject>> _listActiveObjects() {
    return (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false) & tbl.isActive.equals(true))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<Map<String, String>> _loadObjectNames() async {
    final objects = await (_db.select(_db.catalogObjects)
          ..where((tbl) => tbl.isDeleted.equals(false)))
        .get();
    return {for (final object in objects) object.id: object.name};
  }

  Future<Map<String, List<InspectionItem>>> _loadAnswersByInspection(
    Iterable<String> inspectionIds,
  ) async {
    final ids = inspectionIds.toList(growable: false);
    if (ids.isEmpty) {
      return const {};
    }

    final answers = await (_db.select(_db.inspectionItems)
          ..where((tbl) => tbl.inspectionId.isIn(ids)))
        .get();
    final answersByInspection = <String, List<InspectionItem>>{};
    for (final answer in answers) {
      answersByInspection.putIfAbsent(answer.inspectionId, () => []).add(answer);
    }
    return answersByInspection;
  }

  Future<Map<String, List<String>>> _loadComponentImagePaths(
    Iterable<String> componentIds,
  ) async {
    final ids = componentIds.toList(growable: false);
    if (ids.isEmpty) {
      return const {};
    }

    final images = await (_db.select(_db.componentImages)
          ..where(
            (tbl) =>
                tbl.componentId.isIn(ids) &
                tbl.isDeleted.equals(false),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.sortOrder),
            (tbl) => OrderingTerm.asc(tbl.fileName),
          ]))
        .get();
    final result = <String, List<String>>{};
    for (final image in images) {
      final localPath = nullableField(image.localPath);
      if (localPath == null) {
        continue;
      }
      result.putIfAbsent(image.componentId, () => []).add(
            _paths.resolveRelativePath(localPath),
          );
    }
    return result;
  }

  Future<List<InspectionSignatureView>> _loadSignatures(String inspectionId) async {
    final signatures = await (_db.select(_db.inspectionSignatures)
          ..where((tbl) => tbl.inspectionId.equals(inspectionId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.signedAt),
          ]))
        .get();
    return signatures
        .map(
          (signature) => InspectionSignatureView(
            id: signature.id,
            signerUserId: signature.signerUserId,
            signerName: signature.signerName,
            signerRole: signature.signerRole,
            imageRelativePath: signature.imageLocalPath,
            imageAbsolutePath: _paths.resolveRelativePath(signature.imageLocalPath),
            checksum: signature.checksum,
            signedAt: signature.signedAt,
          ),
        )
        .toList(growable: false);
  }

  InspectionPdfInfo? _loadPdfInfo(Inspection inspection) {
    final relativePath = nullableField(inspection.pdfLocalPath);
    final checksum = nullableField(inspection.pdfChecksum);
    if (relativePath == null || checksum == null) {
      return null;
    }
    return InspectionPdfInfo(
      relativePath: relativePath,
      absolutePath: _paths.resolveRelativePath(relativePath),
      checksum: checksum,
    );
  }

  InspectionReportDocumentInput _buildReportDocumentInput(
    InspectionDraftDetail detail,
  ) {
    return InspectionReportDocumentInput(
      inspectionId: detail.inspection.id,
      status: detail.inspection.status,
      productName: detail.productName,
      targetName: detail.targetName,
      startedAt: detail.inspection.startedAt,
      completedAt: detail.inspection.completedAt,
      items: detail.items
          .map(
            (item) => InspectionReportItem(
              title: item.title,
              resultLabel: _resultLabel(item.resultStatus),
              componentName: item.componentName,
              description: item.description,
              expectedResult: item.expectedResult,
              comment: item.comment,
              measuredValue: item.measuredValue,
            ),
          )
          .toList(growable: false),
      signers: detail.signatures
          .map(
            (signature) => InspectionReportSigner(
              name: signature.signerName,
              role: signature.signerRole,
              signedAt: signature.signedAt,
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _upsertInspectionPdfFile({
    required String inspectionId,
    required String fileName,
    required String relativePath,
    required String checksum,
    required String updatedAt,
  }) async {
    final existing = await (_db.select(_db.inspectionFiles)
          ..where(
            (tbl) =>
                tbl.inspectionId.equals(inspectionId) & tbl.fileType.equals('pdf'),
          ))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.inspectionFiles).insert(
            InspectionFilesCompanion.insert(
              id: generateId('inspection-file'),
              inspectionId: inspectionId,
              fileType: 'pdf',
              fileName: fileName,
              localPath: relativePath,
              checksum: checksum,
              mimeType: 'application/pdf',
              createdAt: updatedAt,
              updatedAt: updatedAt,
            ),
          );
      return;
    }

    await (_db.update(_db.inspectionFiles)..where((tbl) => tbl.id.equals(existing.id)))
        .write(
      InspectionFilesCompanion(
        fileName: Value(fileName),
        localPath: Value(relativePath),
        checksum: Value(checksum),
        mimeType: const Value('application/pdf'),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  void _validateCompletion(InspectionDraftDetail detail) {
    final missingRequired = detail.items.where(
      (item) => item.isRequired && item.resultStatus == 'not_checked',
    );
    if (missingRequired.isNotEmpty) {
      throw StateError(
        'Complete all required checklist items before finishing the inspection.',
      );
    }
    if (detail.signatures.isEmpty) {
      throw StateError('At least one signature is required before completion.');
    }
  }

  Future<Directory> _exportResultPackage(
    InspectionDraftDetail detail,
    InspectionPdfInfo pdfInfo,
  ) async {
    final packageDir = Directory(
      p.join(_paths.syncOutgoingDir.path, 'inspection_${detail.inspection.id}'),
    );
    if (await packageDir.exists()) {
      await packageDir.delete(recursive: true);
    }
    final dataDir = Directory(p.join(packageDir.path, 'data'));
    final filesDir = Directory(p.join(packageDir.path, 'files'));
    await dataDir.create(recursive: true);
    await filesDir.create(recursive: true);

    final inspectionFiles = await (_db.select(_db.inspectionFiles)
          ..where((tbl) => tbl.inspectionId.equals(detail.inspection.id)))
        .get();

    final copiedSignatures = <Map<String, Object?>>[];
    for (final signature in detail.signatures) {
      final source = File(signature.imageAbsolutePath);
      if (!await source.exists()) {
        continue;
      }
      final target = File(p.join(filesDir.path, p.basename(signature.imageAbsolutePath)));
      await source.copy(target.path);
      copiedSignatures.add({
        'id': signature.id,
        'signer_user_id': signature.signerUserId,
        'signer_name': signature.signerName,
        'signer_role': signature.signerRole,
        'image_local_path': 'files/${p.basename(target.path)}',
        'checksum': signature.checksum,
        'signed_at': signature.signedAt,
      });
    }

    final pdfSource = File(pdfInfo.absolutePath);
    String? packagedPdfPath;
    if (await pdfSource.exists()) {
      final target = File(p.join(filesDir.path, p.basename(pdfSource.path)));
      await pdfSource.copy(target.path);
      packagedPdfPath = 'files/${p.basename(target.path)}';
    }

    final inspectionPayload = {
      'id': detail.inspection.id,
      'device_id': detail.inspection.deviceId,
      'user_id': detail.inspection.userId,
      'product_object_id': detail.inspection.productObjectId,
      'target_object_id': detail.inspection.targetObjectId,
      'started_at': detail.inspection.startedAt,
      'completed_at': detail.inspection.completedAt,
      'status': detail.inspection.status,
      'sync_status': detail.inspection.syncStatus,
      'source_reference_package_id': detail.inspection.sourceReferencePackageId,
      'source_reference_version': detail.inspection.sourceReferenceVersion,
      'pdf_local_path': packagedPdfPath,
      'pdf_checksum': pdfInfo.checksum,
      'conflict_reason': detail.inspection.conflictReason,
      'created_at': detail.inspection.createdAt,
      'updated_at': detail.inspection.updatedAt,
    };
    final itemsPayload = detail.items
        .map(
          (item) => {
            'answer_id': item.answerId,
            'checklist_item_id': item.checklistItemId,
            'title': item.title,
            'result_type': item.resultType,
            'result_status': item.resultStatus,
            'component_id': item.componentId,
            'component_name': item.componentName,
            'comment': item.comment,
            'measured_value': item.measuredValue,
            'sort_order': item.sortOrder,
          },
        )
        .toList(growable: false);
    final filesPayload = inspectionFiles
        .map(
          (file) => {
            'id': file.id,
            'file_type': file.fileType,
            'file_name': file.fileName,
            'local_path': file.fileType == 'pdf' ? packagedPdfPath : file.localPath,
            'checksum': file.checksum,
            'mime_type': file.mimeType,
            'created_at': file.createdAt,
            'updated_at': file.updatedAt,
          },
        )
        .toList(growable: false);

    await File(p.join(dataDir.path, 'inspection.json')).writeAsString(
      const JsonEncoder.withIndent('  ').convert(inspectionPayload),
    );
    await File(p.join(dataDir.path, 'inspection_items.json')).writeAsString(
      const JsonEncoder.withIndent('  ').convert(itemsPayload),
    );
    await File(p.join(dataDir.path, 'inspection_signatures.json')).writeAsString(
      const JsonEncoder.withIndent('  ').convert(copiedSignatures),
    );
    await File(p.join(dataDir.path, 'inspection_files.json')).writeAsString(
      const JsonEncoder.withIndent('  ').convert(filesPayload),
    );

    final manifest = {
      'package_id': detail.inspection.id,
      'package_type': 'inspection_result',
      'schema_version': AppConstants.syncSchemaVersion,
      'created_at': nowIso(),
      'inspection_id': detail.inspection.id,
      'files': {
        'pdf': packagedPdfPath,
        'signatures': copiedSignatures.length,
      },
    };
    final manifestWithChecksum = {
      ...manifest,
      'checksum': checksumBytes(utf8.encode(jsonEncode(manifest))),
    };
    await File(p.join(packageDir.path, 'manifest.json')).writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifestWithChecksum),
    );

    return packageDir;
  }

  Future<String> _enqueueResultPackage({
    required String inspectionId,
    required Directory packageDirectory,
    required String updatedAt,
  }) async {
    final existing = await (_db.select(_db.syncQueue)
          ..where(
            (tbl) =>
                tbl.packageType.equals('inspection_result') &
                tbl.packageId.equals(inspectionId),
          ))
        .getSingleOrNull();
    if (existing == null) {
      final id = generateId('queue');
      await _db.into(_db.syncQueue).insert(
            SyncQueueCompanion.insert(
              id: id,
              direction: 'outgoing',
              packageType: 'inspection_result',
              packageId: inspectionId,
              localPath: _paths.relativeToRoot(packageDirectory.path),
              status: 'pending',
              createdAt: updatedAt,
              updatedAt: updatedAt,
            ),
          );
      return id;
    }

    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(existing.id))).write(
      SyncQueueCompanion(
        localPath: Value(_paths.relativeToRoot(packageDirectory.path)),
        status: const Value('pending'),
        lastError: const Value(null),
        updatedAt: Value(updatedAt),
      ),
    );
    return existing.id;
  }

  void _ensureEditableInspection(Inspection inspection) {
    if (!_isEditableStatus(inspection.status)) {
      throw StateError('Completed inspections are read-only.');
    }
  }

  bool _isEditableStatus(String status) {
    return status == 'draft' || status == 'in_progress';
  }

  bool _belongsToProduct({
    required String targetId,
    required String productId,
    required Map<String, CatalogObject> objectsById,
  }) {
    String? currentId = targetId;
    while (currentId != null) {
      if (currentId == productId) {
        return true;
      }
      currentId = objectsById[currentId]?.parentId;
    }

    return false;
  }

  String _resultLabel(String status) {
    return switch (status) {
      'pass' => 'Pass',
      'fail' => 'Fail',
      'na' => 'N/A',
      _ => 'Not checked',
    };
  }
}
