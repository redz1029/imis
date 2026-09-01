import 'package:json_annotation/json_annotation.dart';
import 'package:imis/office/models/office.dart'; 

part 'audit_plan_process.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlanProcess {
  final int id;
  final int? officeId;
  final Office? office;
  final String? processName;
  final int auditPlanEntryId;

  AuditPlanProcess({
    required this.id,
    this.officeId,
    this.office,
    this.processName,
    required this.auditPlanEntryId,
  });

  factory AuditPlanProcess.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanProcessFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanProcessToJson(this);
}