// import 'package:imis/pgs/pgs_status.dart';
// import 'package:imis/settings/key_result_area/key_result_area.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'pgs_deliverables.g.dart';

// @JsonSerializable()
// class PgsDeliverables {
//   int id;
//   KeyResultArea keyResultArea;
//   bool isDirect;
//   String deliverableName;
//   DateTime byWhen;
//   double percentDeliverables;
//   PgsStatus status;
//   String? remarks;

//   PgsDeliverables(this.id, this.keyResultArea, this.deliverableName,
//       this.isDirect, this.byWhen, this.percentDeliverables, this.status,
//       {this.remarks});

//   factory PgsDeliverables.fromJson(Map<String, dynamic> json) =>
//       _$PgsDeliverablesFromJson(json);

//   Map<String, dynamic> toJson() => _$PgsDeliverablesToJson(this);
// }
import 'package:imis/pgs/pgs_status.dart';
import 'package:imis/settings/key_result_area/key_result_area.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'pgs_deliverables.g.dart';

@JsonSerializable()
class PgsDeliverables {
  int? id; // ✅ Allow null for new entries
  @JsonKey()
  KeyResultArea kra;
  bool isDirect;
  String deliverableName;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime byWhen; // ✅ Convert DateTime to UTC format

  double percentDeliverables;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  PgsStatus status;

  String? remarks;
  String? rowVersion;

  PgsDeliverables(this.id, this.kra, this.deliverableName, this.isDirect,
      this.byWhen, this.percentDeliverables, this.status,
      {this.remarks, this.rowVersion});

  /// ✅ Custom JSON conversion for `DateTime`
  static DateTime _fromJson(String date) => DateTime.parse(date).toUtc();
  static String _toJson(DateTime date) => date.toUtc().toIso8601String();

  /// ✅ Custom JSON conversion for `PgsStatus` Enum
  static PgsStatus _statusFromJson(int status) => PgsStatus.values[status];
  static int _statusToJson(PgsStatus status) => status.index;
}
