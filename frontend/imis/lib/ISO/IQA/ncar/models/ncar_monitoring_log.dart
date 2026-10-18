class NcarMonitoringLog {
  final int id;
  final String ncarNo;
  final int? nonconformingActionReportId;
  final String deptSectionUnit;
  final DateTime dateIssued;
  final String issuedByName;
  final String itemNoRelevantStandard;
  final String auditeeName;
  final DateTime? dateVerified;
  final String? verifiedByAuditorName;
  final DateTime? dateValidated;
  final String remarks;
  final bool isOverdue;

  const NcarMonitoringLog({
    this.id = 0,
    required this.ncarNo,
    this.nonconformingActionReportId,
    required this.deptSectionUnit,
    required this.dateIssued,
    required this.issuedByName,
    required this.itemNoRelevantStandard,
    required this.auditeeName,
    this.dateVerified,
    this.verifiedByAuditorName,
    this.dateValidated,
    this.remarks = 'Active',
    this.isOverdue = false,
  });

  factory NcarMonitoringLog.fromJson(Map<String, dynamic> json) {
    DateTime parseDt(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      }
      return DateTime.now();
    }

    DateTime? parseOptDt(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val);
      }
      return null;
    }

    return NcarMonitoringLog(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      ncarNo: (json['ncarNo'] ?? json['NcarNo'] ?? '').toString(),
      nonconformingActionReportId: json['nonconformingActionReportId'] ?? json['NonconformingActionReportId'],
      deptSectionUnit: (json['deptSectionUnit'] ?? json['DeptSectionUnit'] ?? '').toString(),
      dateIssued: parseDt(json['dateIssued'] ?? json['DateIssued']),
      issuedByName: (json['issuedByName'] ?? json['IssuedByName'] ?? '').toString(),
      itemNoRelevantStandard: (json['itemNoRelevantStandard'] ?? json['ItemNoRelevantStandard'] ?? '').toString(),
      auditeeName: (json['auditeeName'] ?? json['AuditeeName'] ?? '').toString(),
      dateVerified: parseOptDt(json['dateVerified'] ?? json['DateVerified']),
      verifiedByAuditorName: json['verifiedByAuditorName'] ?? json['VerifiedByAuditorName'],
      dateValidated: parseOptDt(json['dateValidated'] ?? json['DateValidated']),
      remarks: (json['remarks'] ?? json['Remarks'] ?? 'Active').toString(),
      isOverdue: (json['isOverdue'] ?? json['IsOverdue'] ?? false) == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ncarNo': ncarNo,
        'nonconformingActionReportId': nonconformingActionReportId,
        'deptSectionUnit': deptSectionUnit,
        'dateIssued': dateIssued.toIso8601String(),
        'issuedByName': issuedByName,
        'itemNoRelevantStandard': itemNoRelevantStandard,
        'auditeeName': auditeeName,
        'dateVerified': dateVerified?.toIso8601String(),
        'verifiedByAuditorName': verifiedByAuditorName,
        'dateValidated': dateValidated?.toIso8601String(),
        'remarks': remarks,
        'isOverdue': isOverdue,
      };
}
