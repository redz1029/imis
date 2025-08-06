import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverable_score_history.g.dart';

@JsonSerializable()
class PgsDeliverableScoreHistory {
  int id;
  bool isDeleted;
  String? rowVersion;
  int pgsDeliverableId;
  DateTime date;
  int score;

  PgsDeliverableScoreHistory(
    this.id,
    this.isDeleted,
    this.pgsDeliverableId,
    this.date,
    this.score, {
    this.rowVersion,
  });

  factory PgsDeliverableScoreHistory.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableScoreHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableScoreHistoryToJson(this);
}
