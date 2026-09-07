// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_head_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceHeadOffice _$ServiceHeadOfficeFromJson(Map<String, dynamic> json) =>
    ServiceHeadOffice(
      (json['id'] as num).toInt(),
      json['userId'] as String,
      (json['officeId'] as num).toInt(),
      json['isDeleted'] as bool?,
      userFullName: json['userFullName'] as String?,
      officeName: json['officeName'] as String?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$ServiceHeadOfficeToJson(ServiceHeadOffice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'officeId': instance.officeId,
      'officeName': instance.officeName,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
