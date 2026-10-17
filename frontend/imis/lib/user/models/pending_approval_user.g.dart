// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_approval_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingApprovalUser _$PendingApprovalUserFromJson(Map<String, dynamic> json) =>
    PendingApprovalUser(
      id: json['id'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      position: json['position'] as String,
      lockoutEnabled: json['lockoutEnabled'] as bool,
      isLockedOut: json['isLockedOut'] as bool,
      lockoutEnd:
          json['lockoutEnd'] == null
              ? null
              : DateTime.parse(json['lockoutEnd'] as String),
      isPendingApproval: json['isPendingApproval'] as bool,
    );

Map<String, dynamic> _$PendingApprovalUserToJson(
  PendingApprovalUser instance,
) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'email': instance.email,
  'firstName': instance.firstName,
  'middleName': instance.middleName,
  'lastName': instance.lastName,
  'position': instance.position,
  'lockoutEnabled': instance.lockoutEnabled,
  'isLockedOut': instance.isLockedOut,
  'lockoutEnd': instance.lockoutEnd?.toIso8601String(),
  'isPendingApproval': instance.isPendingApproval,
};
