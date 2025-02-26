import 'package:imis/pgs/pgs_status.dart';
import 'package:imis/settings/key_result_area/key_result_area.dart';
import 'package:json_annotation/json_annotation.dart';


part 'pgs_deliverables.g.dart';

@JsonSerializable()
class PgsDeliverables {
  int id;
  KeyResultArea keyResultArea;
  bool isDirect;
  String deliverableName;
  DateTime byWhen;
  double percentDeliverables;
  PgsStatus status;
  String? remarks;

  PgsDeliverables(this.id, this.keyResultArea, this.deliverableName,
      this.isDirect, this.byWhen, this.percentDeliverables, this.status,
      {this.remarks});

  factory PgsDeliverables.fromJson(Map<String, dynamic> json) =>
      _$PgsDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$PgsDeliverablesToJson(this);
}
