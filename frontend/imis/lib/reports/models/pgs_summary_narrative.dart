import 'package:json_annotation/json_annotation.dart';

part 'pgs_summary_narrative.g.dart';

@JsonSerializable()
class PgsSummaryNarrative {
  int id;
  final int pgsPeriodId;
  String? findings;
  String? recommendation;
  String? conclusion;
  bool? isDeleted;
  String? rowVersion;

  PgsSummaryNarrative(
    this.id,
    this.pgsPeriodId,
    this.findings,
    this.recommendation,
    this.conclusion, {
    this.isDeleted,
    this.rowVersion,
  });
  factory PgsSummaryNarrative.fromJson(Map<String, dynamic> json) =>
      _$PgsSummaryNarrativeFromJson(json);

  Map<String, dynamic> toJson() => _$PgsSummaryNarrativeToJson(this);
}
