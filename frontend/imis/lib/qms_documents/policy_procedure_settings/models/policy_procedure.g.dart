// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_procedure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyProcedure _$PolicyProcedureFromJson(Map<String, dynamic> json) =>
    PolicyProcedure(
      id: (json['id'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool,
      rowVersion: json['rowVersion'] as String?,
      numbering: (json['numbering'] as num).toInt(),
      sequence: json['sequence'] as String,
    );

Map<String, dynamic> _$PolicyProcedureToJson(PolicyProcedure instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'numbering': instance.numbering,
      'sequence': instance.sequence,
    };
