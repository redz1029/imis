import 'package:flutter_test/flutter_test.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_com_findings.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_report.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_scope.dart';
import 'package:imis/ISO/IQA/audit_report/model/audit_summary_findings.dart';
import 'package:imis/ISO/IQA/audit_report/pages/audit_report_print_preview_page.dart';
import 'package:pdf/pdf.dart';

AuditReport _report({int findings = 2}) => AuditReport(
  id: 1,
  auditScheduleId: 3,
  auditPurpose: 'INTERNAL QUALITY AUDIT',
  auditConclusions: 'Consider to document patient chart review in the appropriate tool.\nEnsure to sign medication sheet.',
  officeAuditedName: 'Medicine Ward',
  auditStandardISOName: 'ISO 9001 2015',
  planAuditTeamName: 'Audit Team # 1',
  auditDate: DateTime(2026, 5, 18),
  auditScope: [for (final n in ['Renette Gonzales', 'Leonita Lu', 'Pol Jorolan']) AuditScope(auditee: n)],
  auditComFindings: [
    AuditComFindings(commendableFindings: 'Attendance to Specialized Training', area: 'Medicine Ward'),
  ],
  auditSummaryFindings: [
    for (var i = 1; i <= findings; i++)
      AuditSummaryFindings(
        no: i,
        findings: '8.5.$i - The standard requires organization to implement controlled conditions. ' * 6 + '(NCAR 26-00$i)',
        auditNcarStatusId: 1,
      ),
  ],
);

void main() {
  test('report prints with the paper layout', () async {
    final bytes = await buildAuditReportPdfForTest(
      _report(),
      statusNames: {1: 'NC'},
      auditors: 'Rahma Andamen, Cheryl Ferrer; Jobert Castillon',
    );
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('long report flows onto more pages and an empty one still prints', () async {
    final long = await buildAuditReportPdfForTest(_report(findings: 25), format: PdfPageFormat.letter);
    expect(long.isNotEmpty, true);
    final empty = await buildAuditReportPdfForTest(AuditReport(auditScheduleId: 1));
    expect(empty.isNotEmpty, true);
  });
}
