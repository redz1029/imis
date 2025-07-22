// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_result_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyResultArea _$KeyResultAreaFromJson(Map<String, dynamic> json) =>
    KeyResultArea(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['remarks'] as String?,
      json['isDeleted'] as bool,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$KeyResultAreaToJson(KeyResultArea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'remarks': instance.remarks,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
