// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Procedures _$ProceduresFromJson(Map<String, dynamic> json) => Procedures(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  title: json['title'] as String?,
  processOwner: json['processOwner'] as String?,
  regulatoryStandard: json['regulatoryStandard'] as String?,
  effectiveDate:
      json['effectiveDate'] == null
          ? null
          : DateTime.parse(json['effectiveDate'] as String),
  sectionId: (json['sectionId'] as num?)?.toInt(),
  officeName: json['officeName'] as String?,
  documentCode: json['documentCode'] as String?,
  revision: json['revision'] as String?,
  content: json['content'] as String?,
  isMasterCopy: json['isMasterCopy'] as bool?,
  isControlledCopy: json['isControlledCopy'] as bool?,
  minutesAttachmentPath: json['minutesAttachmentPath'] as String?,
  removeAttachment: json['removeAttachment'] as bool?,
  papSignatories:
      (json['papSignatories'] as List<dynamic>?)
          ?.map((e) => PapSignatory.fromJson(e as Map<String, dynamic>))
          .toList(),
  isDraft: json['isDraft'] as bool?,
  forSignature: json['forSignature'] as bool?,
);

Map<String, dynamic> _$ProceduresToJson(
  Procedures instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'title': instance.title,
  'processOwner': instance.processOwner,
  'regulatoryStandard': instance.regulatoryStandard,
  'effectiveDate': instance.effectiveDate?.toIso8601String(),
  'sectionId': instance.sectionId,
  'officeName': instance.officeName,
  'documentCode': instance.documentCode,
  'revision': instance.revision,
  'content': instance.content,
  'isMasterCopy': instance.isMasterCopy,
  'isControlledCopy': instance.isControlledCopy,
  'removeAttachment': instance.removeAttachment,
  'papSignatories': instance.papSignatories?.map((e) => e.toJson()).toList(),
  'isDraft': instance.isDraft,
  'forSignature': instance.forSignature,
};
