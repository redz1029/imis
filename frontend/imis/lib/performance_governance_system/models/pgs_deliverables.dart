import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_deliverables.g.dart';

@JsonSerializable()
class PgsDeliverables {
  int id;

  @JsonKey()
  KeyResultArea kra;

  bool isDirect;
  String deliverableName;

  @JsonKey()
  @DateTimeConverter()
  DateTime byWhen;

  double percentDeliverables;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  PgsStatus status;

  String? remarks;
  String? rowVersion;

  PgsDeliverables(
    this.id,
    this.kra,
    this.deliverableName,
    this.isDirect,
    this.byWhen,
    this.percentDeliverables,
    this.status, {

    this.remarks,
    this.rowVersion,
  });

  factory PgsDeliverables.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverablesToJson(this);

  /// ✅ Custom JSON conversion for `PgsStatus` Enum
  static PgsStatus _statusFromJson(int status) => PgsStatus.values[status];
  static int _statusToJson(PgsStatus status) => status.index;
}
