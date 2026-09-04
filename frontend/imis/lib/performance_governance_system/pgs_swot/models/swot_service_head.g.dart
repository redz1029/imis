// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot_service_head.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwotServiceHead _$SwotServiceHeadFromJson(Map<String, dynamic> json) =>
    SwotServiceHead(
      id: (json['id'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      departmentName: json['departmentName'] as String?,
      objectiveStatement: json['objectiveStatement'] as String?,
      departmentChairUserId: json['departmentChairUserId'] as String?,
      departmentChairUserFullName:
          json['departmentChairUserFullName'] as String?,
      serviceHeadUserId: json['serviceHeadUserId'] as String?,
      serviceHeadUserFullName: json['serviceHeadUserFullName'] as String?,
      postingDate: _$JsonConverterFromJson<String, DateTime>(
        json['postingDate'],
        const DateTimeConverter().fromJson,
      ),
      swotAnalysisSWDeliverables:
          (json['swotAnalysisSWDeliverables'] as List<dynamic>?)
              ?.map(
                (e) => SwotSwDeliverableServiceHead.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      swotAnalysisOTDeliverables:
          (json['swotAnalysisOTDeliverables'] as List<dynamic>?)
              ?.map(
                (e) => SwotOtDeliverableServiceHead.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );

Map<String, dynamic> _$SwotServiceHeadToJson(SwotServiceHead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'objectiveStatement': instance.objectiveStatement,
      'departmentChairUserId': instance.departmentChairUserId,
      'departmentChairUserFullName': instance.departmentChairUserFullName,
      'serviceHeadUserId': instance.serviceHeadUserId,
      'serviceHeadUserFullName': instance.serviceHeadUserFullName,
      'postingDate': _$JsonConverterToJson<String, DateTime>(
        instance.postingDate,
        const DateTimeConverter().toJson,
      ),
      'swotAnalysisSWDeliverables': instance.swotAnalysisSWDeliverables,
      'swotAnalysisOTDeliverables': instance.swotAnalysisOTDeliverables,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
