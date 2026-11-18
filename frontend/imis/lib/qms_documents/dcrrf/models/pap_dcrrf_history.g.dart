// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pap_dcrrf_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PapDcrrfHistory _$PapDcrrfHistoryFromJson(Map<String, dynamic> json) =>
    PapDcrrfHistory(
      id: (json['id'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      policyAndProcedureLogList:
          (json['policyAndProcedureLogList'] as List<dynamic>?)
              ?.map(
                (e) => PapDcrrfHistoryLog.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$PapDcrrfHistoryToJson(PapDcrrfHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'policyAndProcedureLogList':
          instance.policyAndProcedureLogList?.map((e) => e.toJson()).toList(),
    };

PapDcrrfHistoryLog _$PapDcrrfHistoryLogFromJson(Map<String, dynamic> json) =>
    PapDcrrfHistoryLog(
      id: (json['id'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      policyAndProcedureHistoryLogId:
          (json['policyAndProcedureHistoryLogId'] as num?)?.toInt(),
      documentCode: json['documentCode'] as String?,
      pageNo: json['pageNo'] as String?,
      revision: json['revision'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      reasons: json['reasons'] as String?,
    );

Map<String, dynamic> _$PapDcrrfHistoryLogToJson(PapDcrrfHistoryLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'policyAndProcedureHistoryLogId': instance.policyAndProcedureHistoryLogId,
      'documentCode': instance.documentCode,
      'pageNo': instance.pageNo,
      'revision': instance.revision,
      'date': instance.date?.toIso8601String(),
      'reasons': instance.reasons,
    };
