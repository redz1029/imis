// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOffice _$UserOfficeFromJson(Map<String, dynamic> json) => UserOffice(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  json['rowVersion'] as String?,
  json['userId'] as String?,
  (json['officeId'] as num?)?.toInt(),
  json['isActive'] as bool,
  json['firstName'] as String?,
  json['middleName'] as String?,
  json['lastName'] as String?,
  json['prefix'] as String?,
  json['suffix'] as String?,
  json['position'] as String?,
  json['isOfficeHead'] as bool,
);

Map<String, dynamic> _$UserOfficeToJson(UserOffice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'userId': instance.userId,
      'officeId': instance.officeId,
      'isActive': instance.isActive,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'prefix': instance.prefix,
      'suffix': instance.suffix,
      'position': instance.position,
      'isOfficeHead': instance.isOfficeHead,
    };
