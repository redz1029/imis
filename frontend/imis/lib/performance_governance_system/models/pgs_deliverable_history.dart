import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverable_history.g.dart';

@JsonSerializable()
class PgsDeliverableHistory {
  int? id;
  int? pgsId;
  int? deliverableId;
  String? deliverableName;
  String? kraDescription;
  int? kraId;
  String? disapprovalRemarks;
  bool? isDisapproved;
  bool? isDirect;
  double? percentDeliverables;

  @JsonKey()
  @DateTimeConverter()
  DateTime? byWhen;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  PgsStatus? status;

  String? remarks;

  @JsonKey()
  @DateTimeConverter()
  DateTime? removedAt;

  bool? isDeleted;
  String? rowVersion;

  PgsDeliverableHistory({
    this.id,
    this.pgsId,
    this.deliverableId,
    this.deliverableName,
    this.kraDescription,
    this.kraId,
    this.disapprovalRemarks,
    this.isDisapproved,
    this.isDirect,
    this.percentDeliverables,
    this.byWhen,
    this.status,
    this.remarks,
    this.removedAt,
    this.isDeleted,
    this.rowVersion,
  });

  static PgsStatus? _statusFromJson(int? status) {
    if (status == null) return null;
    try {
      return PgsStatus.values.firstWhere(
        (e) => e.index == status,
        orElse: () => PgsStatus.values.first,
      );
    } catch (e) {
      return PgsStatus.values.first;
    }
  }

  static int? _statusToJson(PgsStatus? status) => status?.index;

  factory PgsDeliverableHistory.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverableHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverableHistoryToJson(this);
}
