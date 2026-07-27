// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverables _$PgsDeliverablesFromJson(Map<String, dynamic> json) =>
    PgsDeliverables(
      (json['id'] as num?)?.toInt(),
      json['kra'] == null
          ? null
          : KeyResultArea.fromJson(json['kra'] as Map<String, dynamic>),
      (json['kraId'] as num?)?.toInt(),
      json['deliverableName'] as String,
      json['kraDescription'] as String?,
      json['isDirect'] as bool,
      const DateTimeConverter().fromJson(json['byWhen'] as String),
      (json['percentDeliverables'] as num).toDouble(),
      json['disapprovalRemarks'] as String?,
      json['isDisapproved'] as bool,
      PgsDeliverables._statusFromJson((json['status'] as num).toInt()),
      (json['perfomanceGovernanceSystemId'] as num?)?.toInt(),
      pgsDeliverableHistory:
          (json['pgsDeliverableHistory'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PgsDeliverableHistory.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      remarks: json['remarks'] as String?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$PgsDeliverablesToJson(PgsDeliverables instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kraId': instance.kraId,
      'kra': instance.kra,
      'isDirect': instance.isDirect,
      'deliverableName': instance.deliverableName,
      'kraDescription': instance.kraDescription,
      'byWhen': const DateTimeConverter().toJson(instance.byWhen),
      'percentDeliverables': instance.percentDeliverables,
      'status': PgsDeliverables._statusToJson(instance.status),
      'remarks': instance.remarks,
      'disapprovalRemarks': instance.disapprovalRemarks,
      'isDisapproved': instance.isDisapproved,
      'rowVersion': instance.rowVersion,
      'perfomanceGovernanceSystemId': instance.perfomanceGovernanceSystemId,
      'pgsDeliverableHistory': instance.pgsDeliverableHistory,
    };
