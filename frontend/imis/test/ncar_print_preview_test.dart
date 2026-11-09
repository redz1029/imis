import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:imis/ISO/IQA/ncar/models/ncar_attachment.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_print_preview_page.dart';
import 'package:pdf/pdf.dart';

const _png =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

NonconformingActionReport _ncar({bool full = true}) => NonconformingActionReport(
  id: 1,
  referenceNumber: '26-002',
  office: 'Pediatric Intensive Care Unit',
  relevantStandard: '7.2',
  auditDate: DateTime(2026, 4, 22),
  standardRequirement:
      'The standard requires that an organization must ensure that employees are capable.',
  legalOrPolicyReference: 'In accordance with AO 155, s. 2004, all healthcare workers.',
  auditFindings: List.filled(8, 'Only 11 out of 27 staff had updated BLS training.').join(' '),
  issuedByAuditorUserId: 'a',
  issuedByAuditorName: 'Ms. Honeylet R. Mangulamas',
  acknowledgedByAuditeeUserId: 'b',
  acknowledgedByAuditeeName: 'Mary Jane O. Superales',
  isInternalAudit: true,
  isNonconformity: true,
  isClosed: true,
  verificationDetails: full ? 'Upon verification of the proposed action it was observed.' : null,
  rootCauses: full ? List.generate(5, (i) => 'Root cause number ${i + 1}') : const [],
  corrections: full ? List.generate(3, (i) => 'Correction ${i + 1}') : const [],
  correctiveActions: full ? List.generate(4, (i) => 'Corrective ${i + 1}') : const [],
);

List<NcarAttachment> _pics(int n) => [
  for (var i = 0; i < n; i++)
    NcarAttachment(
      id: i + 1,
      ncarId: 1,
      fileName: 'p$i.png',
      caption: i.isEven ? 'Caption $i' : null,
      bytes: base64Decode(_png),
    ),
];

void main() {
  test('form alone prints on one page', () async {
    final bytes = await buildNcarPdfForTest(_ncar(), const [], PdfPageFormat.a4);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(RegExp('/Type /Page\b').allMatches(latin1.decode(bytes)).length, 1);
  });

  test('empty form still prints', () async {
    final bytes = await buildNcarPdfForTest(_ncar(full: false), const [], PdfPageFormat.letter);
    expect(bytes.isNotEmpty, true);
  });

  test('pictures go on following pages', () async {
    final bytes = await buildNcarPdfForTest(_ncar(), _pics(5), PdfPageFormat.a4);
    final pages = RegExp('/Type /Page\b').allMatches(latin1.decode(bytes)).length;
    expect(pages, greaterThanOrEqualTo(3));
  });
}
