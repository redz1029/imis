// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pgs _$PgsFromJson(Map<String, dynamic> json) => Pgs(
      (json['id'] as num).toInt(),
      PgsPeriod.fromJson(json['pgsPeriod'] as Map<String, dynamic>),
      Office.fromJson(json['office'] as Map<String, dynamic>),
      (json['deliverables'] as List<dynamic>)
          .map((e) => PgsDeliverables.fromJson(e as Map<String, dynamic>))
          .toList(),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$PgsToJson(Pgs instance) => <String, dynamic>{
      'id': instance.id,
      'pgsPeriod': instance.pgsPeriod,
      'office': instance.office,
      'remarks': instance.remarks,
      'deliverables': instance.deliverables,
    };
