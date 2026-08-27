import 'package:imis/performance_validation_tool/pgs_swot/models/swot_ot_deliverable.dart';
import 'package:imis/performance_validation_tool/pgs_swot/models/swot_sw_deliverable.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'swot.g.dart';

@JsonSerializable()
class Swot {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? departmentId;

  String? departmentName;

  String? objectiveStatement;

  String? departmentChairUserId;

  String? departmentChairUserFullName;

  String? qmrUserId;

  String? qmrUserFullName;

  String? serviceHeadUserId;

  String? serviceHeadUserFullName;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  List<SwotSwDeliverable>? swotAnalysisSWDeliverables;

  List<SwotOtDeliverable>? swotAnalysisOTDeliverables;

  Swot({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.departmentId,
    this.departmentName,
    this.objectiveStatement,
    this.departmentChairUserId,
    this.departmentChairUserFullName,
    this.qmrUserId,
    this.qmrUserFullName,
    this.serviceHeadUserId,
    this.serviceHeadUserFullName,
    this.postingDate,
    this.swotAnalysisSWDeliverables,
    this.swotAnalysisOTDeliverables,
  });

  factory Swot.fromJson(Map<String, dynamic> json) => _$SwotFromJson(json);

  Map<String, dynamic> toJson() => _$SwotToJson(this);
}
