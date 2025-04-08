// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  (json['id'] as num).toInt(),
  json['firstName'] as String,
  json['middleName'] as String,
  json['lastName'] as String,
  json['position'] as String,
  Office.fromJson(json['office'] as Map<String, dynamic>),
  json['accessToken'] as String,
  json['refreshToken'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'middleName': instance.middleName,
  'lastName': instance.lastName,
  'position': instance.position,
  'office': instance.office,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
