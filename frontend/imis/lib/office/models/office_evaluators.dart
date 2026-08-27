import 'package:json_annotation/json_annotation.dart';

part 'office_evaluators.g.dart';

@JsonSerializable()
class OfficeEvaluators {
  int? id;
  String? userId;
  int? officeId;
  String officeName;
  bool? isDeleted;
  String? rowVersion;

  OfficeEvaluators({
    this.id,
    this.userId,
    this.officeId,
    required this.officeName,
    this.isDeleted,
    this.rowVersion,
  });

  factory OfficeEvaluators.fromJson(Map<String, dynamic> json) =>
      _$OfficeEvaluatorsFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeEvaluatorsToJson(this);
}
