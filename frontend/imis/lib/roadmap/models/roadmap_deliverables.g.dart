// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapDeliverableItem _$RoadmapDeliverableItemFromJson(
  Map<String, dynamic> json,
) => RoadmapDeliverableItem(
  id: (json['id'] as num).toInt(),
  deliverableDescription: json['deliverableDescription'] as String,
  year: (json['year'] as num).toInt(),
  kraDescription: json['kraDescription'] as String?,
  isEnabler: json['isEnabler'] as bool,
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$RoadmapDeliverableItemToJson(
  RoadmapDeliverableItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'deliverableDescription': instance.deliverableDescription,
  'year': instance.year,
  'kraDescription': instance.kraDescription,
  'isEnabler': instance.isEnabler,
};

DeliverableGroup _$DeliverableGroupFromJson(Map<String, dynamic> json) =>
    DeliverableGroup(
      id: (json['id'] as num).toInt(),
      kraDescription: json['kraDescription'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => RoadmapDeliverableItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$DeliverableGroupToJson(DeliverableGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'kraDescription': instance.kraDescription,
      'items': instance.items,
    };
