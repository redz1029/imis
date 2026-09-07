// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluator_offices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvaluatorOffices _$EvaluatorOfficesFromJson(Map<String, dynamic> json) =>
    EvaluatorOffices(
      id: (json['id'] as num).toInt(),
      userId: json['userId'] as String?,
      userFullName: json['userFullName'] as String?,
      officeId: (json['officeId'] as num).toInt(),
      officeName: json['officeName'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$EvaluatorOfficesToJson(EvaluatorOffices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'officeId': instance.officeId,
      'officeName': instance.officeName,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
