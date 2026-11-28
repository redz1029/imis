// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_document_distribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeDocumentDistribution _$OfficeDocumentDistributionFromJson(
  Map<String, dynamic> json,
) => OfficeDocumentDistribution(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  policyAndProcedureOfficeDocumentDistributionId:
      (json['policyAndProcedureOfficeDocumentDistributionId'] as num?)?.toInt(),
  copyHolderUserId: json['copyHolderUserId'] as String?,
  officeId: (json['officeId'] as num?)?.toInt(),
  issuanceDate:
      json['issuanceDate'] == null
          ? null
          : DateTime.parse(json['issuanceDate'] as String),
  issuanceRevision: json['issuanceRevision'] as String?,
  retrievalDate:
      json['retrievalDate'] == null
          ? null
          : DateTime.parse(json['retrievalDate'] as String),
  retrievalRevision: json['retrievalRevision'] as String?,
);

Map<String, dynamic> _$OfficeDocumentDistributionToJson(
  OfficeDocumentDistribution instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'policyAndProcedureOfficeDocumentDistributionId':
      instance.policyAndProcedureOfficeDocumentDistributionId,
  'copyHolderUserId': instance.copyHolderUserId,
  'officeId': instance.officeId,
  'issuanceDate': instance.issuanceDate?.toIso8601String(),
  'issuanceRevision': instance.issuanceRevision,
  'retrievalDate': instance.retrievalDate?.toIso8601String(),
  'retrievalRevision': instance.retrievalRevision,
};
