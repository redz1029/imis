// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_evaluators.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeEvaluators _$OfficeEvaluatorsFromJson(Map<String, dynamic> json) =>
    OfficeEvaluators(
      id: (json['id'] as num?)?.toInt(),
      userId: json['userId'] as String?,
      officeId: (json['officeId'] as num?)?.toInt(),
      officeName: json['officeName'] as String,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$OfficeEvaluatorsToJson(OfficeEvaluators instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'officeId': instance.officeId,
      'officeName': instance.officeName,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
