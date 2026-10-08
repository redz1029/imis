// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_employee_office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatEmployeeOffice _$IsatEmployeeOfficeFromJson(Map<String, dynamic> json) =>
    IsatEmployeeOffice(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['parentOfficeId'] as num).toInt(),
      json['parentOfficeName'] as String,
    );

Map<String, dynamic> _$IsatEmployeeOfficeToJson(IsatEmployeeOffice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentOfficeId': instance.parentOfficeId,
      'parentOfficeName': instance.parentOfficeName,
    };
