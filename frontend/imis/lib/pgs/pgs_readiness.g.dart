// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_readiness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsReadiness _$PgsReadinessFromJson(Map<String, dynamic> json) => PgsReadiness(
      (json['id'] as num).toInt(),
      json['isDeleted'] as bool,
      json['rowVersion'] as String?,
      (json['competenceToDeliver'] as num).toDouble(),
      (json['resourceAvailability'] as num).toDouble(),
      (json['confidenceToDeliver'] as num).toDouble(),
      (json['totalScore'] as num).toDouble(),
    );

