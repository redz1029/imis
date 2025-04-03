import 'package:imis/performance_governance_system/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performance_governance_system.g.dart';

@JsonSerializable()
class PerformanceGovernanceSystem {
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

  PerformanceGovernanceSystem(
    this.id,
    this.pgsPeriod,
    this.office,
    this.pgsDeliverables,
    this.pgsReadinessRating,
    this.isDeleted, {
    this.remarks,
    this.rowVersion,
  });

  factory PerformanceGovernanceSystem.fromJson(Map<String, dynamic> json) =>
      _$PerformanceGovernanceSystemFromJson(json);
  Map<String, dynamic> toJson() => _$PerformanceGovernanceSystemToJson(this);
}
