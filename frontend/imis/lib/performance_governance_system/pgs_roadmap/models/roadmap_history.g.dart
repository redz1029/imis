// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapHistory _$RoadmapHistoryFromJson(Map<String, dynamic> json) =>
    RoadmapHistory(
      kraDescription: json['kraDescription'] as String?,
      year: (json['year'] as num?)?.toInt(),
      deliverableDescription: json['deliverableDescription'] as String?,
      kraRoadmapName: json['kraRoadmapName'] as String?,
      postingDate: const IsoDateTimeConverter().fromJson(
        json['postingDate'] as String?,
      ),
      userFullName: json['userFullName'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$RoadmapHistoryToJson(RoadmapHistory instance) =>
    <String, dynamic>{
      'kraDescription': instance.kraDescription,
      'year': instance.year,
      'deliverableDescription': instance.deliverableDescription,
      'kraRoadmapName': instance.kraRoadmapName,
      'postingDate': const IsoDateTimeConverter().toJson(instance.postingDate),
      'userFullName': instance.userFullName,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
