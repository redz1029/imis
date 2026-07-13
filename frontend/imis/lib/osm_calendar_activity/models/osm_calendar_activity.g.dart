// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'osm_calendar_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OsmCalendarActivity _$OsmCalendarActivityFromJson(Map<String, dynamic> json) =>
    OsmCalendarActivity(
      (json['id'] as num).toInt(),
      json['title'] as String,
      const DateTimeConverter().fromJson(json['startDate'] as String),
      description: json['description'] as String?,
      isAllDay: json['isAllDay'] as bool?,
      color: json['color'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      status: (json['status'] as num?)?.toInt(),
      userId: json['userId'] as String?,
      officeId: (json['officeId'] as num?)?.toInt(),
      reminderMinutes: (json['reminderMinutes'] as num?)?.toInt(),
      meetingLink: json['meetingLink'] as String?,
      attachmentPath: json['attachmentPath'] as String?,
    );

Map<String, dynamic> _$OsmCalendarActivityToJson(
  OsmCalendarActivity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'isAllDay': instance.isAllDay,
  'color': instance.color,
  'category': instance.category,
  'location': instance.location,
  'status': instance.status,
  'userId': instance.userId,
  'officeId': instance.officeId,
  'reminderMinutes': instance.reminderMinutes,
  'meetingLink': instance.meetingLink,
  'attachmentPath': instance.attachmentPath,
};
