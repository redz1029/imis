// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_approval_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingApprovalUser _$PendingApprovalUserFromJson(Map<String, dynamic> json) =>
    PendingApprovalUser(
      id: PendingApprovalUser._idFromJson(json['id']),
      userName: json['userName'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      position: json['position'] as String,
      lockoutEnabled: json['lockoutEnabled'] as bool? ?? false,
      lockoutEnd:
          json['lockoutEnd'] == null
              ? null
              : DateTime.parse(json['lockoutEnd'] as String),
      isPendingApproval: json['isPendingApproval'] as bool? ?? false,
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
  'lockoutEnd': instance.lockoutEnd?.toIso8601String(),
  'isPendingApproval': instance.isPendingApproval,
};

PendingApprovalUserPage _$PendingApprovalUserPageFromJson(
  Map<String, dynamic> json,
) => PendingApprovalUserPage(
  items:
      (json['data'] as List<dynamic>?)
          ?.map((e) => PendingApprovalUser.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 15,
);

Map<String, dynamic> _$PendingApprovalUserPageToJson(
  PendingApprovalUserPage instance,
) => <String, dynamic>{
  'data': instance.items,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
