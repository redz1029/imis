import 'package:intl/intl.dart';

class IQAApprovalHistory {
  final int id;
  final String auditEntityType;
  final int auditEntityId;
  final int? auditProgrammeId;
  final int? auditPlanId;
  final int? auditScheduleId;
  final String action;
  final String status;
  final String userId;
  final String? userName;
  final String? userFullName;
  final DateTime actionDate;
  final String? comments;
  final String? officeName;
  final String? roleOrPosition;

  const IQAApprovalHistory({
    this.id = 0,
    required this.auditEntityType,
    required this.auditEntityId,
    this.auditProgrammeId,
    this.auditPlanId,
    this.auditScheduleId,
    required this.action,
    required this.status,
    required this.userId,
    this.userName,
    this.userFullName,
    required this.actionDate,
    this.comments,
    this.officeName,
    this.roleOrPosition,
  });

  factory IQAApprovalHistory.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final rawDate = json['actionDate'] ?? json['ActionDate'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return IQAApprovalHistory(
      id: json['id'] ?? json['Id'] ?? 0,
      auditEntityType: json['auditEntityType'] ?? json['AuditEntityType'] ?? '',
      auditEntityId: json['auditEntityId'] ?? json['AuditEntityId'] ?? 0,
      auditProgrammeId: json['auditProgrammeId'] ?? json['AuditProgrammeId'],
      auditPlanId: json['auditPlanId'] ?? json['AuditPlanId'],
      auditScheduleId: json['auditScheduleId'] ?? json['AuditScheduleId'],
      action: json['action'] ?? json['Action'] ?? '',
      status: json['status'] ?? json['Status'] ?? '',
      userId: json['userId'] ?? json['UserId'] ?? '',
      userName: json['userName'] ?? json['UserName'],
      userFullName: json['userFullName'] ?? json['UserFullName'],
      actionDate: parsedDate,
      comments: json['comments'] ?? json['Comments'],
      officeName: json['officeName'] ?? json['OfficeName'],
      roleOrPosition: json['roleOrPosition'] ?? json['RoleOrPosition'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'auditEntityType': auditEntityType,
        'auditEntityId': auditEntityId,
        'auditProgrammeId': auditProgrammeId,
        'auditPlanId': auditPlanId,
        'auditScheduleId': auditScheduleId,
        'action': action,
        'status': status,
        'userId': userId,
        'userName': userName,
        'userFullName': userFullName,
        'actionDate': actionDate.toIso8601String(),
        'comments': comments,
        'officeName': officeName,
        'roleOrPosition': roleOrPosition,
      };

  String get effectiveUserName =>
      (userFullName != null && userFullName!.isNotEmpty)
          ? userFullName!
          : (userName ?? userId);

  String get formattedDate =>
      DateFormat('MMM d, yyyy h:mm a').format(actionDate.toLocal());

  static List<IQAApprovalHistory> listFromJson(Object? json) {
    if (json is List) {
      return json.map((e) {
        if (e is IQAApprovalHistory) return e;
        if (e is Map<String, dynamic>) return IQAApprovalHistory.fromJson(e);
        if (e is Map) {
          return IQAApprovalHistory.fromJson(Map<String, dynamic>.from(e));
        }
        return IQAApprovalHistory.fromJson(const {});
      }).toList();
    }
    return [];
  }
}

class RejectionDetails {
  final String? rejectedBy;
  final String? rejectedByUserId;
  final DateTime? rejectedDate;
  final String? rejectionReason;
  final String? officeName;
  final String? roleOrPosition;

  const RejectionDetails({
    this.rejectedBy,
    this.rejectedByUserId,
    this.rejectedDate,
    this.rejectionReason,
    this.officeName,
    this.roleOrPosition,
  });

  factory RejectionDetails.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final rawDate = json['rejectedDate'] ?? json['RejectedDate'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return RejectionDetails(
      rejectedBy: json['rejectedBy'] ?? json['RejectedBy'],
      rejectedByUserId: json['rejectedByUserId'] ?? json['RejectedByUserId'],
      rejectedDate: parsedDate,
      rejectionReason: json['rejectionReason'] ?? json['RejectionReason'],
      officeName: json['officeName'] ?? json['OfficeName'],
      roleOrPosition: json['roleOrPosition'] ?? json['RoleOrPosition'],
    );
  }

  Map<String, dynamic> toJson() => {
        'rejectedBy': rejectedBy,
        'rejectedByUserId': rejectedByUserId,
        'rejectedDate': rejectedDate?.toIso8601String(),
        'rejectionReason': rejectionReason,
        'officeName': officeName,
        'roleOrPosition': roleOrPosition,
      };

  String get formattedDate => rejectedDate != null
      ? DateFormat('MMMM d, yyyy h:mm a').format(rejectedDate!.toLocal())
      : '—';
}
