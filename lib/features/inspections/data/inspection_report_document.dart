class InspectionReportItem {
  const InspectionReportItem({
    required this.title,
    required this.resultLabel,
    this.componentName,
    this.description,
    this.expectedResult,
    this.comment,
    this.measuredValue,
  });

  final String title;
  final String resultLabel;
  final String? componentName;
  final String? description;
  final String? expectedResult;
  final String? comment;
  final String? measuredValue;
}

class InspectionReportSigner {
  const InspectionReportSigner({
    required this.name,
    required this.role,
    required this.signedAt,
  });

  final String name;
  final String role;
  final String signedAt;
}

class InspectionReportDocumentInput {
  const InspectionReportDocumentInput({
    required this.inspectionId,
    required this.status,
    required this.productName,
    required this.targetName,
    required this.startedAt,
    required this.completedAt,
    required this.items,
    required this.signers,
  });

  final String inspectionId;
  final String status;
  final String productName;
  final String targetName;
  final String startedAt;
  final String? completedAt;
  final List<InspectionReportItem> items;
  final List<InspectionReportSigner> signers;
}

List<String> buildInspectionReportLines(InspectionReportDocumentInput input) {
  final lines = <String>[
    'OKK QC Inspection Report',
    'Inspection ID: ${input.inspectionId}',
    'Status: ${input.status}',
    'Product: ${input.productName}',
    'Target: ${input.targetName}',
    'Started at: ${input.startedAt}',
    'Completed at: ${input.completedAt ?? 'not completed'}',
    '',
    'Items',
  ];

  for (var index = 0; index < input.items.length; index++) {
    final item = input.items[index];
    lines.add('${index + 1}. ${item.title}');
    lines.add('   Result: ${item.resultLabel}');
    if ((item.componentName ?? '').isNotEmpty) {
      lines.add('   Component: ${item.componentName}');
    }
    if ((item.description ?? '').isNotEmpty) {
      lines.add('   Description: ${item.description}');
    }
    if ((item.expectedResult ?? '').isNotEmpty) {
      lines.add('   Expected: ${item.expectedResult}');
    }
    if ((item.measuredValue ?? '').isNotEmpty) {
      lines.add('   Value: ${item.measuredValue}');
    }
    if ((item.comment ?? '').isNotEmpty) {
      lines.add('   Comment: ${item.comment}');
    }
  }

  lines.add('');
  lines.add('Signatures');
  if (input.signers.isEmpty) {
    lines.add('No signatures recorded.');
  } else {
    for (final signer in input.signers) {
      lines.add('- ${signer.name} (${signer.role}) at ${signer.signedAt}');
    }
  }

  return lines;
}

String buildInspectionReportPreviewText(InspectionReportDocumentInput input) {
  return buildInspectionReportLines(input).join('\n');
}

List<int> buildInspectionPdfBytes(InspectionReportDocumentInput input) {
  final sourceLines = buildInspectionReportLines(input);
  final lines = sourceLines.length > 42
      ? <String>[
          ...sourceLines.take(41),
          '... truncated in PDF output; see app preview for full report.',
        ]
      : sourceLines;

  final operations = <String>[
    'BT',
    '/F1 11 Tf',
    '50 792 Td',
  ];
  for (var index = 0; index < lines.length; index++) {
    final escaped = _escapePdfText(_asciiSafe(lines[index]));
    if (index == 0) {
      operations.add('($escaped) Tj');
    } else {
      operations.add('0 -16 Td');
      operations.add('($escaped) Tj');
    }
  }
  operations.add('ET');

  final content = operations.join('\n');
  final objects = <String>[
    '1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n',
    '2 0 obj\n<< /Type /Pages /Count 1 /Kids [3 0 R] >>\nendobj\n',
    '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>\nendobj\n',
    '4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
    '5 0 obj\n<< /Length ${content.length} >>\nstream\n$content\nendstream\nendobj\n',
  ];

  final buffer = StringBuffer('%PDF-1.4\n');
  final offsets = <int>[0];
  for (final object in objects) {
    offsets.add(buffer.length);
    buffer.write(object);
  }

  final xrefOffset = buffer.length;
  buffer.write('xref\n');
  buffer.write('0 ${objects.length + 1}\n');
  buffer.write('0000000000 65535 f \n');
  for (var index = 1; index < offsets.length; index++) {
    final offset = offsets[index].toString().padLeft(10, '0');
    buffer.write('$offset 00000 n \n');
  }
  buffer.write(
    'trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n$xrefOffset\n%%EOF',
  );

  return buffer.toString().codeUnits;
}

String _escapePdfText(String value) {
  return value
      .replaceAll('\\', r'\\')
      .replaceAll('(', r'\(')
      .replaceAll(')', r'\)')
      .replaceAll('\r', ' ')
      .replaceAll('\n', ' ');
}

String _asciiSafe(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    if (rune >= 32 && rune <= 126) {
      buffer.writeCharCode(rune);
    } else {
      buffer.write('?');
    }
  }
  return buffer.toString();
}
