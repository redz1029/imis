// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  rowVersion: json['rowVersion'] as String?,
  remarks: json['remarks'] as String,
  isdelete: json['isdelete'] as bool?,
);

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'rowVersion': instance.rowVersion,
  'remarks': instance.remarks,
  'isdelete': instance.isdelete,
};
