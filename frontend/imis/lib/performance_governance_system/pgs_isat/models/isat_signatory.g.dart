// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_signatory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatSignatory _$IsatSignatoryFromJson(Map<String, dynamic> json) =>
    IsatSignatory(
      id: (json['id'] as num?)?.toInt(),
      isatId: (json['isatId'] as num?)?.toInt(),
      isatSignatoryTemplateId:
          (json['isatSignatoryTemplateId'] as num?)?.toInt(),
      signatoryId: json['signatoryId'] as String?,
      signatoryName: json['signatoryName'] as String?,
      dateSigned:
          json['dateSigned'] == null
              ? null
              : DateTime.parse(json['dateSigned'] as String),
      label: json['label'] as String?,
      status: json['status'] as String?,
      orderLevel: (json['orderLevel'] as num?)?.toInt() ?? 0,
      isNextStatus: json['isNextStatus'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$IsatSignatoryToJson(IsatSignatory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isatId': instance.isatId,
      'isatSignatoryTemplateId': instance.isatSignatoryTemplateId,
      'signatoryId': instance.signatoryId,
      'signatoryName': instance.signatoryName,
      'dateSigned': instance.dateSigned?.toIso8601String(),
      'label': instance.label,
      'status': instance.status,
      'orderLevel': instance.orderLevel,
      'isNextStatus': instance.isNextStatus,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
