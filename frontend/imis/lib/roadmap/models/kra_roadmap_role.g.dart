// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kra_roadmap_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KraRoadmapRole _$KraRoadmapRoleFromJson(Map<String, dynamic> json) =>
    KraRoadmapRole(
      id: (json['id'] as num?)?.toInt(),
      rowVersion: json['rowVersion'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      kraId: (json['kraId'] as num).toInt(),
      roleId: json['roleId'] as String,
      kraName: json['kraName'] as String,
    );

Map<String, dynamic> _$KraRoadmapRoleToJson(KraRoadmapRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kraId': instance.kraId,
      'roleId': instance.roleId,
      'kraName': instance.kraName,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
