/// A Department Head's request to move an audit schedule. It is approved by
/// the Auditor Team Leader, then the Lead Auditor, before the schedule is
/// revised.
class RescheduleRequest {
  static const String pendingTeamLeader = 'Pending Team Leader';
  static const String pendingLeadAuditor = 'Pending Lead Auditor';
  static const String approved = 'Approved';
  static const String rejectedByTeamLeader = 'Rejected by Team Leader';
  static const String rejectedByLeadAuditor = 'Rejected by Lead Auditor';

  final int id;
  final int auditScheduleId;
  final int auditPlanId;
  final String? officeName;
  final DateTime currentStartDate;
  final DateTime proposedStartDate;
  final String? reason;
  final String status;
  final String? requestedBy;
  final DateTime? requestedDate;
  final String? teamLeaderRemarks;
  final String? leadAuditorRemarks;

  /// True when the signed-in user is the approver the request is waiting on.
  final bool canDecide;

  const RescheduleRequest({
    required this.id,
    required this.auditScheduleId,
    required this.auditPlanId,
    this.officeName,
    required this.currentStartDate,
    required this.proposedStartDate,
    this.reason,
    required this.status,
    this.requestedBy,
    this.requestedDate,
    this.teamLeaderRemarks,
    this.leadAuditorRemarks,
    this.canDecide = false,
  });

  bool get isPending =>
      status == pendingTeamLeader || status == pendingLeadAuditor;

  bool get isRejected =>
      status == rejectedByTeamLeader || status == rejectedByLeadAuditor;

  /// Remarks of whoever rejected the request.
  String? get rejectionRemarks => status == rejectedByTeamLeader
      ? teamLeaderRemarks
      : leadAuditorRemarks;

  factory RescheduleRequest.fromJson(Map<String, dynamic> json) {
    DateTime parse(dynamic v) => DateTime.parse(v.toString());
    return RescheduleRequest(
      id: (json['id'] as num?)?.toInt() ?? 0,
      auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
      auditPlanId: (json['auditPlanId'] as num?)?.toInt() ?? 0,
      officeName: json['officeName'] as String?,
      currentStartDate: parse(json['currentStartDate']),
      proposedStartDate: parse(json['proposedStartDate']),
      reason: json['reason'] as String?,
      status: (json['status'] as String?) ?? '',
      requestedBy: json['requestedBy'] as String?,
      requestedDate:
          json['requestedDate'] == null ? null : parse(json['requestedDate']),
      teamLeaderRemarks: json['teamLeaderRemarks'] as String?,
      leadAuditorRemarks: json['leadAuditorRemarks'] as String?,
      canDecide: json['canDecide'] == true,
    );
  }
}
