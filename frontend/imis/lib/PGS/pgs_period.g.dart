// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsPeriod _$PgsPeriodFromJson(Map<String, dynamic> json) => PgsPeriod(
      (json['id'] as num).toInt(),
      DateTime.parse(json['startDate'] as String),
      DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$PgsPeriodToJson(PgsPeriod instance) => <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
