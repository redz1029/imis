import 'package:json_annotation/json_annotation.dart';
import 'package:imis/strategy_review_report/models/strategy_review_kpi.dart';
import 'package:imis/strategy_review_report/models/strategy_review_deliverable.dart';
part 'strategy_review_report.g.dart';

@JsonSerializable()
class StrategyReviewSaveRequest {
  final int id;
  final bool? isDeleted;
  final String? rowVersion;
  final String postingDate;
  final int kraRoadMapId;
  final String? strategicObjective;
  final String? officeNames;
  final List<StrategyReviewDeliverableKpiRequest> strategyReviewDeliverableKpi;
  final List<StrategyReviewDeliverableRequest> strategyReviewDeliverable;
  @JsonKey(name: 'continue')
  final String? continueText;
  final String? start;
  final String? stop;
  final String? strategyReviewPeriodId;
  final String? roleId;

  StrategyReviewSaveRequest({
    required this.id,
    this.isDeleted,
    this.rowVersion,
    required this.postingDate,
    required this.kraRoadMapId,
    this.strategicObjective,
    this.officeNames,
    required this.strategyReviewDeliverableKpi,
    required this.strategyReviewDeliverable,
    this.continueText,
    this.start,
    this.stop,
    this.strategyReviewPeriodId,
    this.roleId,
  });

  factory StrategyReviewSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewSaveRequestToJson(this);
}

@JsonSerializable()
class StrategyReviewDeliverableKpiRequest {
  final int id;
  final bool? isDeleted;
  final String? rowVersion;
  final int strategyReviewId;
  final int kpiId;
  final String? actualDate;
  final String? measure;
  final String? target;

  final int status;
  final StrategyReviewKpi? kpiDetails;

  StrategyReviewDeliverableKpiRequest({
    required this.id,
    this.isDeleted,
    this.rowVersion,
    this.measure,
    this.target,

    required this.strategyReviewId,
    required this.kpiId,
    this.actualDate,
    required this.status,
    this.kpiDetails,
  });

  factory StrategyReviewDeliverableKpiRequest.empty() =>
      StrategyReviewDeliverableKpiRequest(
        id: 0,
        strategyReviewId: 0,
        kpiId: 0,
        status: 0,
      );

  factory StrategyReviewDeliverableKpiRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$StrategyReviewDeliverableKpiRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StrategyReviewDeliverableKpiRequestToJson(this);
}

@JsonSerializable()
class StrategyReviewDeliverableRequest {
  final int id;
  final bool? isDeleted;
  final String? rowVersion;
  final int strategyReviewId;
  final int kraRoadmapid;
  final String? actualDate;
  final String? deliverable;
  final String? keyResultArea;
  final int status;
  final StrategyReviewDeliverable? kraRoadMapDeliverableDetails;

  StrategyReviewDeliverableRequest({
    required this.id,
    this.isDeleted,
    this.rowVersion,
    this.deliverable,
    this.keyResultArea,
    required this.strategyReviewId,
    required this.kraRoadmapid,
    this.actualDate,
    required this.status,
    this.kraRoadMapDeliverableDetails,
  });

  factory StrategyReviewDeliverableRequest.empty() =>
      StrategyReviewDeliverableRequest(
        id: 0,
        strategyReviewId: 0,
        kraRoadmapid: 0,
        status: 0,
      );

  factory StrategyReviewDeliverableRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$StrategyReviewDeliverableRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StrategyReviewDeliverableRequestToJson(this);
}

@JsonSerializable()
class StrategyReviewReport {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final String postingDate;
  final int kraRoadMapId;
  final String? strategicObjective;
  final String? officeNames;
  @JsonKey(name: 'continue')
  final String? continueText;
  final String? start;
  final String? stop;
  final List<StrategyReviewDeliverableKpiRequest>? strategyReviewDeliverableKpi;
  final List<StrategyReviewDeliverableRequest>? strategyReviewDeliverable;
  final int? strategyReviewPeriodId;
  final String? roleId;
  final String? strategyReviewPeriod;
  final String? kraRoadMapName;
  StrategyReviewReport({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    required this.postingDate,
    required this.kraRoadMapId,
    this.strategicObjective,
    this.officeNames,
    this.continueText,
    this.start,
    this.stop,
    this.strategyReviewDeliverableKpi,
    this.strategyReviewDeliverable,
    this.strategyReviewPeriodId,
    this.roleId,
    this.strategyReviewPeriod,
    this.kraRoadMapName,
  });

  factory StrategyReviewReport.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewReportFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewReportToJson(this);
}
