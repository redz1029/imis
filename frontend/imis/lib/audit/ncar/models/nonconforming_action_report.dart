class NonconformingActionReport {
  final int id;
  final String referenceNumber;
  final String office;
  final String relevantStandard;
  final DateTime auditDate;
  final bool isInternalAudit;
  final bool isExternalAudit;
  final bool isNonconformity;
  final bool isInternalCustomer;
  final bool isExternalCustomer;
  final bool isComplaint;
  final bool isResponseRate;
  final bool isOperations;
  final String standardRequirement;
  final String legalOrPolicyReference;
  final String auditFindings;
  final int? auditReportId;
  final String issuedByAuditorUserId;
  final String? issuedByAuditorName;
  final DateTime? issuedDate;
  final String acknowledgedByAuditeeUserId;
  final String? acknowledgedByAuditeeName;
  final DateTime? acknowledgedDate;
  final String? proposedByAuditeeUserId;
  final DateTime? proposedDate;
  final String? approvedByHeadUserId;
  final DateTime? approvedDate;
  final String? verificationDetails;
  final String? verifiedByAuditorUserId;
  final DateTime? verifiedDate;
  final String? validatedByLeadAuditorUserId;
  final DateTime? validatedDate;
  final bool isActive;
  final bool isClosed;
  final String formRevision;

  const NonconformingActionReport({
    this.id = 0,
    required this.referenceNumber,
    required this.office,
    required this.relevantStandard,
    required this.auditDate,
    this.isInternalAudit = true,
    this.isExternalAudit = false,
    this.isNonconformity = true,
    this.isInternalCustomer = false,
    this.isExternalCustomer = false,
    this.isComplaint = false,
    this.isResponseRate = false,
    this.isOperations = false,
    required this.standardRequirement,
    required this.legalOrPolicyReference,
    required this.auditFindings,
    this.auditReportId,
    required this.issuedByAuditorUserId,
    this.issuedByAuditorName,
    this.issuedDate,
    required this.acknowledgedByAuditeeUserId,
    this.acknowledgedByAuditeeName,
    this.acknowledgedDate,
    this.proposedByAuditeeUserId,
    this.proposedDate,
    this.approvedByHeadUserId,
    this.approvedDate,
    this.verificationDetails,
    this.verifiedByAuditorUserId,
    this.verifiedDate,
    this.validatedByLeadAuditorUserId,
    this.validatedDate,
    this.isActive = true,
    this.isClosed = false,
    this.formRevision = "QP-03-F-08 Rev. 5",
  });

  factory NonconformingActionReport.fromJson(Map<String, dynamic> json) {
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

    return NonconformingActionReport(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      referenceNumber: (json['referenceNumber'] ?? json['ReferenceNumber'] ?? '').toString(),
      office: (json['office'] ?? json['Office'] ?? '').toString(),
      relevantStandard: (json['relevantStandard'] ?? json['RelevantStandard'] ?? '').toString(),
      auditDate: parseDt(json['auditDate'] ?? json['AuditDate']),
      isInternalAudit: (json['isInternalAudit'] ?? json['IsInternalAudit'] ?? true) == true,
      isExternalAudit: (json['isExternalAudit'] ?? json['IsExternalAudit'] ?? false) == true,
      isNonconformity: (json['isNonconformity'] ?? json['IsNonconformity'] ?? true) == true,
      isInternalCustomer: (json['isInternalCustomer'] ?? json['IsInternalCustomer'] ?? false) == true,
      isExternalCustomer: (json['isExternalCustomer'] ?? json['IsExternalCustomer'] ?? false) == true,
      isComplaint: (json['isComplaint'] ?? json['IsComplaint'] ?? false) == true,
      isResponseRate: (json['isResponseRate'] ?? json['IsResponseRate'] ?? false) == true,
      isOperations: (json['isOperations'] ?? json['IsOperations'] ?? false) == true,
      standardRequirement: (json['standardRequirement'] ?? json['StandardRequirement'] ?? '').toString(),
      legalOrPolicyReference: (json['legalOrPolicyReference'] ?? json['LegalOrPolicyReference'] ?? '').toString(),
      auditFindings: (json['auditFindings'] ?? json['AuditFindings'] ?? '').toString(),
      auditReportId: json['auditReportId'] ?? json['AuditReportId'],
      issuedByAuditorUserId: (json['issuedByAuditorUserId'] ?? json['IssuedByAuditorUserId'] ?? '').toString(),
      issuedByAuditorName: json['issuedByAuditorName'] ?? json['IssuedByAuditorName'],
      issuedDate: parseOptDt(json['issuedDate'] ?? json['IssuedDate']),
      acknowledgedByAuditeeUserId: (json['acknowledgedByAuditeeUserId'] ?? json['AcknowledgedByAuditeeUserId'] ?? '').toString(),
      acknowledgedByAuditeeName: json['acknowledgedByAuditeeName'] ?? json['AcknowledgedByAuditeeName'],
      acknowledgedDate: parseOptDt(json['acknowledgedDate'] ?? json['AcknowledgedDate']),
      proposedByAuditeeUserId: json['proposedByAuditeeUserId'] ?? json['ProposedByAuditeeUserId'],
      proposedDate: parseOptDt(json['proposedDate'] ?? json['ProposedDate']),
      approvedByHeadUserId: json['approvedByHeadUserId'] ?? json['ApprovedByHeadUserId'],
      approvedDate: parseOptDt(json['approvedDate'] ?? json['ApprovedDate']),
      verificationDetails: json['verificationDetails'] ?? json['VerificationDetails'],
      verifiedByAuditorUserId: json['verifiedByAuditorUserId'] ?? json['VerifiedByAuditorUserId'],
      verifiedDate: parseOptDt(json['verifiedDate'] ?? json['VerifiedDate']),
      validatedByLeadAuditorUserId: json['validatedByLeadAuditorUserId'] ?? json['ValidatedByLeadAuditorUserId'],
      validatedDate: parseOptDt(json['validatedDate'] ?? json['ValidatedDate']),
      isActive: (json['isActive'] ?? json['IsActive'] ?? true) == true,
      isClosed: (json['isClosed'] ?? json['IsClosed'] ?? false) == true,
      formRevision: (json['formRevision'] ?? json['FormRevision'] ?? 'QP-03-F-08 Rev. 5').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'referenceNumber': referenceNumber,
        'office': office,
        'relevantStandard': relevantStandard,
        'auditDate': auditDate.toIso8601String(),
        'isInternalAudit': isInternalAudit,
        'isExternalAudit': isExternalAudit,
        'isNonconformity': isNonconformity,
        'isInternalCustomer': isInternalCustomer,
        'isExternalCustomer': isExternalCustomer,
        'isComplaint': isComplaint,
        'isResponseRate': isResponseRate,
        'isOperations': isOperations,
        'standardRequirement': standardRequirement,
        'legalOrPolicyReference': legalOrPolicyReference,
        'auditFindings': auditFindings,
        'auditReportId': auditReportId,
        'issuedByAuditorUserId': issuedByAuditorUserId,
        'issuedDate': issuedDate?.toIso8601String(),
        'acknowledgedByAuditeeUserId': acknowledgedByAuditeeUserId,
        'acknowledgedDate': acknowledgedDate?.toIso8601String(),
        'proposedByAuditeeUserId': proposedByAuditeeUserId,
        'proposedDate': proposedDate?.toIso8601String(),
        'approvedByHeadUserId': approvedByHeadUserId,
        'approvedDate': approvedDate?.toIso8601String(),
        'verificationDetails': verificationDetails,
        'verifiedByAuditorUserId': verifiedByAuditorUserId,
        'verifiedDate': verifiedDate?.toIso8601String(),
        'validatedByLeadAuditorUserId': validatedByLeadAuditorUserId,
        'validatedDate': validatedDate?.toIso8601String(),
        'isActive': isActive,
        'isClosed': isClosed,
        'formRevision': formRevision,
      };

  String get statusDisplay {
    if (isClosed) return 'Closed';
    if (approvedDate != null) return 'Under Monitoring';
    if (acknowledgedDate != null) return 'Acknowledged / Under Review';
    return 'Open / Issued';
  }
}
