import 'package:json_annotation/json_annotation.dart';

part 'policy_procedure.g.dart';

@JsonSerializable()
class PolicyProcedure {
  int id;
  bool isDeleted;
  String? rowVersion;
  int numbering;
  String sequence;
  bool? isFlowChart;

  PolicyProcedure({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    required this.numbering,
    required this.sequence,
    this.isFlowChart,
  });

  factory PolicyProcedure.fromJson(Map<String, dynamic> json) =>
      _$PolicyProcedureFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyProcedureToJson(this);
}
