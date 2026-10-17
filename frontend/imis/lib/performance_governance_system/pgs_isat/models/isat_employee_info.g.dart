// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_employee_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatEmployeeInfo _$IsatEmployeeInfoFromJson(Map<String, dynamic> json) =>
    IsatEmployeeInfo(
      userId: json['userId'] as String?,
      employeeName: json['employeeName'] as String?,
      position: json['position'] as String?,
      officeId: (json['officeId'] as num?)?.toInt(),
      officeName: json['officeName'] as String?,
      supervisorUserId: json['supervisorUserId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      parentOfficeId: (json['parentOfficeId'] as num?)?.toInt(),
      parentOfficeName: json['parentOfficeName'] as String?,
    );

Map<String, dynamic> _$IsatEmployeeInfoToJson(IsatEmployeeInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'employeeName': instance.employeeName,
      'position': instance.position,
      'officeId': instance.officeId,
      'officeName': instance.officeName,
      'supervisorUserId': instance.supervisorUserId,
      'supervisorName': instance.supervisorName,
      'parentOfficeId': instance.parentOfficeId,
      'parentOfficeName': instance.parentOfficeName,
    };
