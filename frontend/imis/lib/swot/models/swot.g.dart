// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Swot _$SwotFromJson(Map<String, dynamic> json) => Swot(
  (json['id'] as num).toInt(),
  json['userId'] as String,
  json['strengths'] as String,
  json['weaknesses'] as String,
  json['opportunities'] as String,
  json['threats'] as String,
  json['longTermDepartmentStrategicPlan'] as String,
  json['immediateNeedsToAchieveVision'] as String,
  json['departmentAchievementsAndBestPractices'] as String,
  json['isDeleted'] as bool?,
  const DateTimeConverter().fromJson(json['postingDate'] as String),
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$SwotToJson(Swot instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'userId': instance.userId,
  'strengths': instance.strengths,
  'weaknesses': instance.weaknesses,
  'opportunities': instance.opportunities,
  'threats': instance.threats,
  'longTermDepartmentStrategicPlan': instance.longTermDepartmentStrategicPlan,
  'immediateNeedsToAchieveVision': instance.immediateNeedsToAchieveVision,
  'departmentAchievementsAndBestPractices':
      instance.departmentAchievementsAndBestPractices,
  'postingDate': const DateTimeConverter().toJson(instance.postingDate),
};
