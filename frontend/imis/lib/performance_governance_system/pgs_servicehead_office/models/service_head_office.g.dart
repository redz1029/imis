// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_head_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceHeadOffice _$ServiceHeadOfficeFromJson(Map<String, dynamic> json) =>
    ServiceHeadOffice(
        (json['id'] as num).toInt(),
        json['userId'] as String,
        json['officeId'] as String,
      )
      ..rowVersion = json['rowVersion'] as String?
      ..isDeleted = json['isDeleted'] as String?;

Map<String, dynamic> _$ServiceHeadOfficeToJson(ServiceHeadOffice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'officeId': instance.officeId,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
