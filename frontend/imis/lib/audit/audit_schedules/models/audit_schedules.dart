
import 'package:imis/audit/iqa_signatory/model/iqa_approval_history.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_schedules.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditSchedules {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String purpose;

  @JsonKey(defaultValue: '')
  final String activity;

  @JsonKey(defaultValue: true)
  final bool isActive;

  final String? rowVersion;

  @DateTimeConverter()
  final DateTime startDate;

  @DateTimeConverter()
  final DateTime endDate;

  @JsonKey(defaultValue: 0)
  final int auditPlanId;

  @JsonKey(defaultValue: 0)
  final int auditPlanEntryId;

  final int? teamId;

  final String? statusCode;
  final String? statusName;

  @JsonKey(
    fromJson: _signatoriesFromJson,
    includeToJson: false,
    defaultValue: [],
  )
  final List<IQASignatory> signatories;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final List<IQAApprovalHistory> approvalHistory;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final RejectionDetails? latestRejection;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final String? officeName;

  const AuditSchedules({
    this.id = 0,
    this.purpose = '',
    this.activity = '',
    this.isActive = true,
    this.rowVersion,
    required this.startDate,
    required this.endDate,
    this.auditPlanId = 0,
    this.auditPlanEntryId = 0,
    this.teamId,
    this.statusCode,
    this.statusName,
    this.signatories = const [],
    this.approvalHistory = const [],
    this.latestRejection,
    this.officeName,
  });

  factory AuditSchedules.fromJson(Map<String, dynamic> json) {
    final base = _$AuditSchedulesFromJson(json);
    final history = IQAApprovalHistory.listFromJson(
      json['approvalHistory'] ?? json['ApprovalHistory'],
    );
    RejectionDetails? rej;
    final rejRaw = json['latestRejection'] ?? json['LatestRejection'];
    if (rejRaw is Map<String, dynamic>) {
      rej = RejectionDetails.fromJson(rejRaw);
    } else if (rejRaw is Map) {
      rej = RejectionDetails.fromJson(Map<String, dynamic>.from(rejRaw));
    }

    final officeName = json['officeName'] ?? json['OfficeName'] as String?;

    return AuditSchedules(
      id: base.id,
      purpose: base.purpose,
      activity: base.activity,
      isActive: base.isActive,
      rowVersion: base.rowVersion,
      startDate: base.startDate,
      endDate: base.endDate,
      auditPlanId: base.auditPlanId,
      auditPlanEntryId: base.auditPlanEntryId,
      teamId: base.teamId,
      statusCode: base.statusCode,
      statusName: base.statusName,
      signatories: base.signatories,
      approvalHistory: history,
      latestRejection: rej,
      officeName: officeName,
    );
  }

  Map<String, dynamic> toJson() => _$AuditSchedulesToJson(this);

  String get effectiveStatusName => statusName ?? 'Pending Confirmation';

  static List<IQASignatory> _signatoriesFromJson(Object? json) =>
      IQASignatory.listFromJson(json);
}