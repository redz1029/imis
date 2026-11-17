// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pap_signatory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PapSignatory _$PapSignatoryFromJson(Map<String, dynamic> json) => PapSignatory(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
  papId: (json['papId'] as num?)?.toInt(),
  papSignatoryTemplateId: (json['papSignatoryTemplateId'] as num?)?.toInt(),
  signatoryId: json['signatoryId'] as String?,
  signatoryName: json['signatoryName'] as String?,
  dateSigned:
      json['dateSigned'] == null
          ? null
          : DateTime.parse(json['dateSigned'] as String),
  label: json['label'] as String?,
  status: json['status'] as String?,
  orderLevel: (json['orderLevel'] as num?)?.toInt(),
  isNextStatus: json['isNextStatus'] as bool?,
);

Map<String, dynamic> _$PapSignatoryToJson(PapSignatory instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.isDeleted case final value?) 'isDeleted': value,
      if (instance.rowVersion case final value?) 'rowVersion': value,
      if (instance.papId case final value?) 'papId': value,
      if (instance.papSignatoryTemplateId case final value?)
        'papSignatoryTemplateId': value,
      if (instance.signatoryId case final value?) 'signatoryId': value,
      if (instance.signatoryName case final value?) 'signatoryName': value,
      if (instance.dateSigned?.toIso8601String() case final value?)
        'dateSigned': value,
      if (instance.label case final value?) 'label': value,
      if (instance.status case final value?) 'status': value,
      if (instance.orderLevel case final value?) 'orderLevel': value,
      if (instance.isNextStatus case final value?) 'isNextStatus': value,
    };
