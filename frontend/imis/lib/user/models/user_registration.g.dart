// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistration _$UserRegistrationFromJson(Map<String, dynamic> json) =>
    UserRegistration(
      json['id'] as String?,
      json['userName'] as String?,
      json['email'] as String?,
      json['password'] as String?,
      json['firstName'] as String?,
      json['middleName'] as String?,
      json['lastName'] as String?,
      json['prefix'] as String?,
      json['suffix'] as String?,
      json['position'] as String?,
      json['accessToken'] as String?,
      json['refreshToken'] as String?,
      _$JsonConverterFromJson<String, DateTime>(
        json['lockoutEnd'],
        const DateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$UserRegistrationToJson(UserRegistration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'prefix': instance.prefix,
      'suffix': instance.suffix,
      'position': instance.position,
      'lockoutEnd': _$JsonConverterToJson<String, DateTime>(
        instance.lockoutEnd,
        const DateTimeConverter().toJson,
      ),
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
