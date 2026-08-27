import 'package:json_annotation/json_annotation.dart';

part 'evaluator_offices.g.dart';

@JsonSerializable()
class EvaluatorOffices {
  final int id;
  final String? userId;
  final String? userFullName;
  final int officeId;
  final String? officeName;
  final bool? isDeleted;
  final String? rowVersion;

  EvaluatorOffices({
    required this.id,
    required this.userId,
    this.userFullName,
    required this.officeId,
    required this.officeName,
    this.isDeleted,
    this.rowVersion,
  });

  factory EvaluatorOffices.fromJson(Map<String, dynamic> json) =>
      _$EvaluatorOfficesFromJson(json);
  Map<String, dynamic> toJson() => _$EvaluatorOfficesToJson(this);
}
