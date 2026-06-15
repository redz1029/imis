// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsFilter _$PgsFilterFromJson(Map<String, dynamic> json) => PgsFilter(
  json['roleId'] as String?,
  (json['pgsPeriodId'] as num?)?.toInt(),
  (json['officeId'] as num?)?.toInt(),
  (json['kraId'] as num?)?.toInt(),
  json['isDirect'] as bool?,
  (json['scoreRangeFrom'] as num?)?.toInt(),
  (json['scoreRangeTo'] as num?)?.toInt(),
  (json['page'] as num?)?.toInt(),
  (json['pageSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$PgsFilterToJson(PgsFilter instance) => <String, dynamic>{
  'roleId': instance.roleId,
  'pgsPeriodId': instance.pgsPeriodId,
  'officeId': instance.officeId,
  'kraId': instance.kraId,
  'isDirect': instance.isDirect,
  'scoreRangeFrom': instance.scoreRangeFrom,
  'scoreRangeTo': instance.scoreRangeTo,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
