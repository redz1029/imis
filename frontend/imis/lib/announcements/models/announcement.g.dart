// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  fromDate: DateTime.parse(json['fromDate'] as String),
  toDate: DateTime.parse(json['toDate'] as String),
  isActive: json['isActive'] as bool,
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool?,
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'fromDate': instance.fromDate.toIso8601String(),
      'toDate': instance.toDate.toIso8601String(),
      'isActive': instance.isActive,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
