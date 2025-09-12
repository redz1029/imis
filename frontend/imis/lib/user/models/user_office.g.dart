// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOffice _$UserOfficeFromJson(Map<String, dynamic> json) => UserOffice(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  userId: json['userId'] as String,
  officeId: (json['officeId'] as num).toInt(),
  isActive: json['isActive'] as bool,
  firstName: json['firstName'] as String,
  middleName: json['middleName'] as String?,
  lastName: json['lastName'] as String,
  prefix: json['prefix'] as String?,
  suffix: json['suffix'] as String?,
  position: json['position'] as String,
  isOfficeHead: json['isOfficeHead'] as bool,
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
