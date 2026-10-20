// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_review_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyReviewOfficeResponse _$StrategyReviewOfficeResponseFromJson(
  Map<String, dynamic> json,
) => StrategyReviewOfficeResponse(
  json['roadmapName'] as String? ?? '',
  (json['deliverables'] as List<dynamic>?)
          ?.map((e) => StrategyReviewOffice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$StrategyReviewOfficeResponseToJson(
  StrategyReviewOfficeResponse instance,
) => <String, dynamic>{
  'roadmapName': instance.roadmapName,
  'deliverables': instance.deliverables.map((e) => e.toJson()).toList(),
};

StrategyReviewOffice _$StrategyReviewOfficeFromJson(
  Map<String, dynamic> json,
) => StrategyReviewOffice(
  json['officeName'] as String? ?? '',
  (json['deliverables'] as List<dynamic>?)
          ?.map(
            (e) => StrategyReviewOfficeDeliverable.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$StrategyReviewOfficeToJson(
  StrategyReviewOffice instance,
) => <String, dynamic>{
  'officeName': instance.officeName,
  'deliverables': instance.deliverables.map((e) => e.toJson()).toList(),
};

StrategyReviewOfficeDeliverable _$StrategyReviewOfficeDeliverableFromJson(
  Map<String, dynamic> json,
) => StrategyReviewOfficeDeliverable(
  (json['pgsDeliverableId'] as num?)?.toInt() ?? 0,
  json['deliverableName'] as String? ?? '',
  accomplishment:
      json['accomplishment'] == null
          ? null
          : StrategyReviewOfficeAccomplishment.fromJson(
            json['accomplishment'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$StrategyReviewOfficeDeliverableToJson(
  StrategyReviewOfficeDeliverable instance,
) => <String, dynamic>{
  'pgsDeliverableId': instance.pgsDeliverableId,
  'deliverableName': instance.deliverableName,
  'accomplishment': instance.accomplishment?.toJson(),
};

StrategyReviewOfficeAccomplishment _$StrategyReviewOfficeAccomplishmentFromJson(
  Map<String, dynamic> json,
) => StrategyReviewOfficeAccomplishment(
  postingDate:
      json['postingDate'] == null
          ? null
          : DateTime.parse(json['postingDate'] as String),
  postingMonth: json['postingMonth'] as String?,
  percentAccomplished: json['percentAccomplished'] as num?,
  remarks: json['remarks'] as String?,
  auditorRemarks: json['auditorRemarks'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$StrategyReviewOfficeAccomplishmentToJson(
  StrategyReviewOfficeAccomplishment instance,
) => <String, dynamic>{
  'postingDate': instance.postingDate?.toIso8601String(),
  'postingMonth': instance.postingMonth,
  'percentAccomplished': instance.percentAccomplished,
  'remarks': instance.remarks,
  'auditorRemarks': instance.auditorRemarks,
  'status': instance.status,
};
