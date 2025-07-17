import 'package:imis/history/models/pgs_deliverable_history.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverables.g.dart';

@JsonSerializable()
class PgsDeliverables {
  int? id;
  int? kraId;

  @JsonKey()
  KeyResultArea kra;

  bool isDirect;
  String deliverableName;
  String kraDescription;

  @JsonKey()
  @DateTimeConverter()
  DateTime byWhen;

  double percentDeliverables;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  PgsStatus status;

  String? remarks;
  String disapprovalRemarks;
  bool isDisapproved;

  String? rowVersion;
  List<PgsDeliverableHistory>? pgsDeliverableHistory;

  PgsDeliverables(
    this.id,
    this.kra,
    this.kraId,
    this.deliverableName,
    this.kraDescription,
    this.isDirect,
    this.byWhen,
    this.percentDeliverables,
    this.disapprovalRemarks,
    this.isDisapproved,
    this.status, {

    this.pgsDeliverableHistory,
    this.remarks,
    this.rowVersion,
  });

  factory PgsDeliverables.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverablesToJson(this);

  static PgsStatus _statusFromJson(int status) => PgsStatus.values[status];
  static int _statusToJson(PgsStatus status) => status.index;
}
