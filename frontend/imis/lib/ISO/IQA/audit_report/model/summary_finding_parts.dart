/// A stored Summary-of-Findings line reads
/// "8.5.1 - the standard requires ... (NCAR NCAR-2026-1006-02018)": the clause
/// is the CRITERIA, the statement the FINDINGS, and the NCAR number the
/// reference of the NCAR raised for it.
class SummaryFindingParts {
  const SummaryFindingParts({
    required this.criteria,
    required this.findings,
    this.ncarRef = '',
  });

  final String criteria;
  final String findings;
  final String ncarRef;
}

SummaryFindingParts splitSummaryFinding(String text) {
  var rest = text.trim();

  var ncarRef = '';
  final ncar = RegExp(r'\s*\(NCAR\s+([^)]+)\)\s*$').firstMatch(rest);
  if (ncar != null) {
    ncarRef = ncar.group(1)!.trim();
    rest = rest.substring(0, ncar.start).trim();
  }

  final m = RegExp(r'^(\S+)\s+-\s+([\s\S]*)$').firstMatch(rest);
  if (m == null) {
    return SummaryFindingParts(criteria: '', findings: rest, ncarRef: ncarRef);
  }
  return SummaryFindingParts(
    criteria: m.group(1)!.trim(),
    findings: m.group(2)!.trim(),
    ncarRef: ncarRef,
  );
}
