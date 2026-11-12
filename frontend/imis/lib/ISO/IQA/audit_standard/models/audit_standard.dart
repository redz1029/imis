/// An audit standard (e.g. "ISO 9001:2015") kept in Settings. Its name is what
/// the Audit Checklist prints as its audit scope and the Audit Report prints
/// as its audit standard.
class AuditStandard {
  final int id;
  String name;
  bool isActive;
  final String? rowVersion;

  AuditStandard({
    this.id = 0,
    required this.name,
    this.isActive = true,
    this.rowVersion,
  });

  factory AuditStandard.fromJson(Map<String, dynamic> json) => AuditStandard(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: (json['versionName'] as String?) ?? '',
    isActive: json['isActive'] != false,
    rowVersion: json['rowVersion'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'versionName': name.trim(),
    'isActive': isActive,
    'isDeleted': false,
    'rowVersion': rowVersion ?? '',
  };
}
