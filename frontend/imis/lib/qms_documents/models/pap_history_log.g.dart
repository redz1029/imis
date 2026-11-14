// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pap_history_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PapHistoryLog _$PapHistoryLogFromJson(Map<String, dynamic> json) =>
    PapHistoryLog(
      id: (json['id'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      policyAndProcedureId: (json['policyAndProcedureId'] as num).toInt(),
      titleName: json['titleName'] as String,
      effectiveDate:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      policyAndProcedureLogList:
          (json['policyAndProcedureLogList'] as List<dynamic>?)
              ?.map(
                (e) => PolicyandProceduresLogList.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$PapHistoryLogToJson(PapHistoryLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'policyAndProcedureId': instance.policyAndProcedureId,
      'titleName': instance.titleName,
      'date': instance.effectiveDate?.toIso8601String(),
      'policyAndProcedureLogList':
          instance.policyAndProcedureLogList.map((e) => e.toJson()).toList(),
    };

PolicyandProceduresLogList _$PolicyandProceduresLogListFromJson(
  Map<String, dynamic> json,
) => PolicyandProceduresLogList(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  policyAndProcedureHistoryLogId:
      (json['policyAndProcedureHistoryLogId'] as num?)?.toInt(),
  documentCode: json['documentCode'] as String?,
  pageNo: json['pageNo'] as String?,
  revision: json['revision'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  reasons: json['reasons'] as String?,
);

Map<String, dynamic> _$PolicyandProceduresLogListToJson(
  PolicyandProceduresLogList instance,
) => <String, dynamic>{
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
