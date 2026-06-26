import 'package:imis/performance_validation_tool/models/pvt_deliverable_findings.dart';
import 'package:imis/performance_validation_tool/models/pvt_objectives.dart';
import 'package:imis/performance_validation_tool/models/pvt_signatories.dart';
import 'package:imis/performance_validation_tool/models/pvt_validators.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performance_validation_tool.g.dart';

@JsonSerializable()
class PerformanceValidationTool {
  int id;
  bool? isDeleted;
  String? rowVersion;
  int performanceValidationToolPeriodId;

  int officeId;

  String? officeHeadUserId;

  @DateTimeConverter()
  DateTime? validateDate;

  String? comment;

  @DateTimeConverter()
  DateTime? postingDate;

  List<PvtValidators>? validators;
  PvtObjectives? objectives;
  List<PvtDeliverableFindings>? deliverableFindings;
  List<PvtSignatories>? pvtSignatories;
  bool? isDraft;
  int performanceGovernanceSystemId;

  PerformanceValidationTool({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    required this.performanceValidationToolPeriodId,
    required this.officeId,
    required this.officeHeadUserId,
    required this.validateDate,
    this.comment,
    this.postingDate,
    required this.validators,
    this.objectives,
    this.deliverableFindings,
    this.pvtSignatories,
    this.isDraft,
    required this.performanceGovernanceSystemId,
  });
  factory PerformanceValidationTool.fromjson(Map<String, dynamic> json) =>
      _$PerformanceValidationToolFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceValidationToolToJson(this);
}
