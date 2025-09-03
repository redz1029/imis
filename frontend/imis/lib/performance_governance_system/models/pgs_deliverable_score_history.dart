import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverable_score_history.g.dart';

@JsonSerializable()
class PgsDeliverableScoreHistory {
  int id;
  bool isDeleted;
  String? rowVersion;
  int pgsDeliverableId;
  DateTime date;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  PgsStatus status;

  String? remarks;
  int score;

  PgsDeliverableScoreHistory(
    this.id,
    this.isDeleted,
    this.pgsDeliverableId,
    this.date,
    this.score,
    this.status, {
    this.remarks,
    this.rowVersion,
  });

  factory PgsDeliverableScoreHistory.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableScoreHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableScoreHistoryToJson(this);
  static PgsStatus _statusFromJson(int status) => PgsStatus.values[status];
  static int _statusToJson(PgsStatus status) => status.index;
}
