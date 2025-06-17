import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverable_history_grouped.g.dart';

@JsonSerializable()
class PgsDeliverableHistoryGrouped {
  int pgsDeliverableId;
  List<PgsDeliverableHistoryGrouped>? scoreHistory;

  PgsDeliverableHistoryGrouped(this.pgsDeliverableId, this.scoreHistory);

  factory PgsDeliverableHistoryGrouped.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableHistoryGroupedFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableHistoryGroupedToJson(this);
}
