import 'package:json_annotation/json_annotation.dart';
part 'breakthrough_scoring.g.dart';

@JsonSerializable()
class BreakthroughScoring {
  int id;
  int? pgsDeliverableId;
  int? percentAccomplishment;
  int? target;
  int? strategic;
  int? breakThrough;
  int? finalScore;
  final bool? isDeleted;
  final String? rowVersion;

  BreakthroughScoring(
    this.id,
    this.pgsDeliverableId,
    this.percentAccomplishment,
    this.target,
    this.strategic,
    this.breakThrough,
    this.finalScore, {
    this.isDeleted,
    this.rowVersion,
  });

  factory BreakthroughScoring.fromJson(Map<String, dynamic> json) =>
      _$BreakthroughScoringFromJson(json);

  Map<String, dynamic> toJson() => _$BreakthroughScoringToJson(this);
}
