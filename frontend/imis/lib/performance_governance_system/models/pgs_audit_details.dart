import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_audit_details.g.dart';

@JsonSerializable()
class PgsAuditDetails {
  int id;

  @JsonKey()
  Office office;

  @JsonKey()
  PgsPeriod pgsPeriod;

  @JsonKey(defaultValue: '')
  String? remarks;

  @JsonKey()
  List<PgsDeliverables> pgsDeliverables;

  @JsonKey()
  PgsReadiness pgsReadinessRating;

  bool isDeleted;
  String? rowVersion;

  PgsAuditDetails(
    this.id,
    this.pgsPeriod,
    this.office,
    this.pgsDeliverables,
    this.pgsReadinessRating,
    this.isDeleted, {
    this.remarks,
    this.rowVersion,
  });

  factory PgsAuditDetails.fromJson(Map<String, dynamic> json) =>
      _$PgsAuditDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PgsAuditDetailsToJson(this);
}
