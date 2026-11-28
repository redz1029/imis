// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_and_procedure_office_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyAndProcedureOfficeDocument _$PolicyAndProcedureOfficeDocumentFromJson(
  Map<String, dynamic> json,
) => PolicyAndProcedureOfficeDocument(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  policyAndProcedureId: (json['policyAndProcedureId'] as num?)?.toInt(),
  postingDate:
      json['postingDate'] == null
          ? null
          : DateTime.parse(json['postingDate'] as String),
  isControlledCopy: json['isControlledCopy'] as bool?,
  isMasterCopy: json['isMasterCopy'] as bool?,
  officeDocumentDistributionList:
      (json['officeDocumentDistributionList'] as List<dynamic>?)
          ?.map(
            (e) =>
                OfficeDocumentDistribution.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$PolicyAndProcedureOfficeDocumentToJson(
  PolicyAndProcedureOfficeDocument instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'policyAndProcedureId': instance.policyAndProcedureId,
  'postingDate': instance.postingDate?.toIso8601String(),
  'isControlledCopy': instance.isControlledCopy,
  'isMasterCopy': instance.isMasterCopy,
  'officeDocumentDistributionList':
      instance.officeDocumentDistributionList?.map((e) => e.toJson()).toList(),
};
