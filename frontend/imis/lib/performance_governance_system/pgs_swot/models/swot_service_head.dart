import 'package:imis/performance_governance_system/pgs_swot/models/swot_ot_deliverable_service_head.dart';
import 'package:imis/performance_governance_system/pgs_swot/models/swot_sw_deliverable_service_head.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'swot_service_head.g.dart';

@JsonSerializable()
class SwotServiceHead {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? departmentId;

  String? departmentName;

  String? objectiveStatement;

  String? departmentChairUserId;

  String? departmentChairUserFullName;

  String? serviceHeadUserId;

  String? serviceHeadUserFullName;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  List<SwotSwDeliverableServiceHead>? swotAnalysisSWDeliverablesServiceHead;

  List<SwotOtDeliverableServiceHead>? swotAnalysisOTDeliverablesServiceHead;

  SwotServiceHead({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.departmentId,
    this.departmentName,
    this.objectiveStatement,
    this.departmentChairUserId,
    this.departmentChairUserFullName,
    this.serviceHeadUserId,
    this.serviceHeadUserFullName,
    this.postingDate,
    this.swotAnalysisSWDeliverablesServiceHead,
    this.swotAnalysisOTDeliverablesServiceHead,
  });

  factory SwotServiceHead.fromJson(Map<String, dynamic> json) =>
      _$SwotServiceHeadFromJson(json);

  Map<String, dynamic> toJson() => _$SwotServiceHeadToJson(this);
}
