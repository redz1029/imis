import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverable_history.g.dart';

@JsonSerializable()
class PgsDeliverableHistory {
  int id;
  bool isDeleted;
  String? rowVersion;
  int pgsDeliverableId;
  DateTime date;
  int score;

  PgsDeliverableHistory(
    this.id,
    this.isDeleted,
    this.pgsDeliverableId,
    this.date,
    this.score, {
    this.rowVersion,
  });

  factory PgsDeliverableHistory.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableHistoryToJson(this);
}
