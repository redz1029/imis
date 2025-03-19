import 'package:imis/pgs/pgs_period.dart';
import 'package:imis/pgs/pgs_readiness.dart';
import 'package:imis/settings/office/office.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'pgs.g.dart';

@JsonSerializable()
class Pgs {
  int id;

  @JsonKey()
  PgsPeriod pgsPeriod;

  @JsonKey()
  Office office;

  String? remarks;
  PgsReadiness pgsReadinessRating;
  bool isDeleted;
  String? rowVersion;

  Pgs(this.id, this.pgsPeriod, this.office, this.pgsReadinessRating,
      this.isDeleted,
      {this.remarks, this.rowVersion});
}
