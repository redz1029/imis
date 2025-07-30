// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverable_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverableHistory _$PgsDeliverableHistoryFromJson(
  Map<String, dynamic> json,
) => PgsDeliverableHistory(
  id: (json['id'] as num?)?.toInt(),
  pgsId: (json['pgsId'] as num?)?.toInt(),
  deliverableId: (json['deliverableId'] as num?)?.toInt(),
  deliverableName: json['deliverableName'] as String?,
  kraDescription: json['kraDescription'] as String?,
  kraId: (json['kraId'] as num?)?.toInt(),
  disapprovalRemarks: json['disapprovalRemarks'] as String?,
  isDisapproved: json['isDisapproved'] as bool?,
  isDirect: json['isDirect'] as bool?,
  percentDeliverables: (json['percentDeliverables'] as num?)?.toDouble(),
  byWhen: _$JsonConverterFromJson<String, DateTime>(
    json['byWhen'],
    const DateTimeConverter().fromJson,
  ),
  status: PgsDeliverableHistory._statusFromJson(
    (json['status'] as num?)?.toInt(),
  ),
  remarks: json['remarks'] as String?,
  removedAt: _$JsonConverterFromJson<String, DateTime>(
    json['removedAt'],
    const DateTimeConverter().fromJson,
  ),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsDeliverableHistoryToJson(
  PgsDeliverableHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'pgsId': instance.pgsId,
  'deliverableId': instance.deliverableId,
  'deliverableName': instance.deliverableName,
  'kraDescription': instance.kraDescription,
  'kraId': instance.kraId,
  'disapprovalRemarks': instance.disapprovalRemarks,
  'isDisapproved': instance.isDisapproved,
  'isDirect': instance.isDirect,
  'percentDeliverables': instance.percentDeliverables,
  'byWhen': _$JsonConverterToJson<String, DateTime>(
    instance.byWhen,
    const DateTimeConverter().toJson,
  ),
  'status': PgsDeliverableHistory._statusToJson(instance.status),
  'remarks': instance.remarks,
  'removedAt': _$JsonConverterToJson<String, DateTime>(
    instance.removedAt,
    const DateTimeConverter().toJson,
  ),
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
