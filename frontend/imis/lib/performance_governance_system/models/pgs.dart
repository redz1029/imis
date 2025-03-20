import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs.g.dart';

@JsonSerializable()
class Pgs {
  int id;

  @JsonKey()
  Office office;

  @JsonKey()
  PgsPeriod pgsPeriod;

  @JsonKey(defaultValue: '')
  String? remarks;

  @JsonKey()
  PgsReadiness pgsReadinessRating;

  bool isDeleted;
  String? rowVersion;

  Pgs(
    this.id,
    this.pgsPeriod,
    this.office,
    this.pgsReadinessRating,
    this.isDeleted, {
    this.remarks,
    this.rowVersion,
  });

  factory Pgs.fromJson(Map<String, dynamic> json) => _$PgsFromJson(json);
  Map<String, dynamic> toJson() => _$PgsToJson(this);
}
