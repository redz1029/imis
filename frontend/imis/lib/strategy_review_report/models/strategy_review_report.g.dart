// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_review_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyReviewSaveRequest _$StrategyReviewSaveRequestFromJson(
  Map<String, dynamic> json,
) => StrategyReviewSaveRequest(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  postingDate: json['postingDate'] as String,
  kraRoadMapId: (json['kraRoadMapId'] as num).toInt(),
  strategicObjective: json['strategicObjective'] as String?,
  officeNames: json['officeNames'] as String?,
  strategyReviewDeliverableKpi:
      (json['strategyReviewDeliverableKpi'] as List<dynamic>)
          .map(
            (e) => StrategyReviewDeliverableKpiRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  strategyReviewDeliverable:
      (json['strategyReviewDeliverable'] as List<dynamic>)
          .map(
            (e) => StrategyReviewDeliverableRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  continueText: json['continue'] as String?,
  start: json['start'] as String?,
  stop: json['stop'] as String?,
);

Map<String, dynamic> _$StrategyReviewSaveRequestToJson(
  StrategyReviewSaveRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'postingDate': instance.postingDate,
  'kraRoadMapId': instance.kraRoadMapId,
  'strategicObjective': instance.strategicObjective,
  'officeNames': instance.officeNames,
  'strategyReviewDeliverableKpi': instance.strategyReviewDeliverableKpi,
  'strategyReviewDeliverable': instance.strategyReviewDeliverable,
  'continue': instance.continueText,
  'start': instance.start,
  'stop': instance.stop,
};

StrategyReviewDeliverableKpiRequest
_$StrategyReviewDeliverableKpiRequestFromJson(Map<String, dynamic> json) =>
    StrategyReviewDeliverableKpiRequest(
      id: (json['id'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      strategyReviewId: (json['strategyReviewId'] as num).toInt(),
      kpiId: (json['kpiId'] as num).toInt(),
      actualDate: json['actualDate'] as String?,
      status: (json['status'] as num).toInt(),
      kpiDetails:
          json['kpiDetails'] == null
              ? null
              : StrategyReviewKpi.fromJson(
                json['kpiDetails'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$StrategyReviewDeliverableKpiRequestToJson(
  StrategyReviewDeliverableKpiRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'strategyReviewId': instance.strategyReviewId,
  'kpiId': instance.kpiId,
  'actualDate': instance.actualDate,
  'status': instance.status,
  'kpiDetails': instance.kpiDetails,
};

StrategyReviewDeliverableRequest _$StrategyReviewDeliverableRequestFromJson(
  Map<String, dynamic> json,
) => StrategyReviewDeliverableRequest(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  strategyReviewId: (json['strategyReviewId'] as num).toInt(),
  kraRoadmapid: (json['kraRoadmapid'] as num).toInt(),
  actualDate: json['actualDate'] as String?,
  status: (json['status'] as num).toInt(),
  kraRoadMapDeliverableDetails:
      json['kraRoadMapDeliverableDetails'] == null
          ? null
          : StrategyReviewDeliverable.fromJson(
            json['kraRoadMapDeliverableDetails'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$StrategyReviewDeliverableRequestToJson(
  StrategyReviewDeliverableRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'strategyReviewId': instance.strategyReviewId,
  'kraRoadmapid': instance.kraRoadmapid,
  'actualDate': instance.actualDate,
  'status': instance.status,
  'kraRoadMapDeliverableDetails': instance.kraRoadMapDeliverableDetails,
};

StrategyReviewReport _$StrategyReviewReportFromJson(
  Map<String, dynamic> json,
) => StrategyReviewReport(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  postingDate: json['postingDate'] as String,
  kraRoadMapId: (json['kraRoadMapId'] as num).toInt(),
  strategicObjective: json['strategicObjective'] as String?,
  officeNames: json['officeNames'] as String?,
  continueText: json['continue'] as String?,
  start: json['start'] as String?,
  stop: json['stop'] as String?,
  strategyReviewDeliverableKpi:
      (json['strategyReviewDeliverableKpi'] as List<dynamic>?)
          ?.map(
            (e) => StrategyReviewDeliverableKpiRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  strategyReviewDeliverable:
      (json['strategyReviewDeliverable'] as List<dynamic>?)
          ?.map(
            (e) => StrategyReviewDeliverableRequest.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic> _$StrategyReviewReportToJson(
  StrategyReviewReport instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'postingDate': instance.postingDate,
  'kraRoadMapId': instance.kraRoadMapId,
  'strategicObjective': instance.strategicObjective,
  'officeNames': instance.officeNames,
  'continue': instance.continueText,
  'start': instance.start,
  'stop': instance.stop,
  'strategyReviewDeliverableKpi': instance.strategyReviewDeliverableKpi,
  'strategyReviewDeliverable': instance.strategyReviewDeliverable,
};
