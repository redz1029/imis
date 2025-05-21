// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverables _$PgsDeliverablesFromJson(Map<String, dynamic> json) =>
    PgsDeliverables(
      (json['id'] as num?)?.toInt(),
      KeyResultArea.fromJson(json['kra'] as Map<String, dynamic>),
      (json['kraId'] as num?)?.toInt(),
      json['deliverableName'] as String,
      json['isDirect'] as bool,
      const DateTimeConverter().fromJson(json['byWhen'] as String),
      (json['percentDeliverables'] as num).toDouble(),
      PgsDeliverables._statusFromJson((json['status'] as num).toInt()),
      remarks: json['remarks'] as String?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$PgsDeliverablesToJson(PgsDeliverables instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kraId': instance.kraId,
      'kra': instance.kra,
      'isDirect': instance.isDirect,
      'deliverableName': instance.deliverableName,
      'byWhen': const DateTimeConverter().toJson(instance.byWhen),
      'percentDeliverables': instance.percentDeliverables,
      'status': PgsDeliverables._statusToJson(instance.status),
      'remarks': instance.remarks,
      'rowVersion': instance.rowVersion,
    };
