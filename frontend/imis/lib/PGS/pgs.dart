import 'package:imis/pgs/pgs_deliverables.dart';
import 'package:imis/pgs/pgs_period.dart';
import 'package:imis/settings/office/office.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs.g.dart';

@JsonSerializable()
class Pgs {
  int id;

  @JsonKey()
  PgsPeriod pgsPeriod;

  @JsonKey()
  Office office;

  String? remarks;

  @JsonKey()
  List<PgsDeliverables> deliverables;

  Pgs(this.id, this.pgsPeriod, this.office, this.deliverables, {this.remarks});

  factory Pgs.fromJSON(Map<String, dynamic> json) => _$PgsFromJson(json);

  Map<String, dynamic> toJson() => _$PgsToJson(this);
}
