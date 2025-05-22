import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performance_governance_system.g.dart';

// @JsonSerializable()
// class PerformanceGovernanceSystem {
//   final int id;

//   @JsonKey()
//   Office office;

//   @JsonKey()
//   PgsPeriod pgsPeriod;

//   @JsonKey(defaultValue: '')
//   String? remarks;

//   @JsonKey()
//   List<PgsDeliverables> pgsDeliverables;

//   @JsonKey()
//   PgsReadiness pgsReadinessRating;

//   bool isDeleted;
//   String? rowVersion;

//   PerformanceGovernanceSystem(
//     this.id,
//     this.pgsPeriod,
//     this.office,
//     this.pgsDeliverables,
//     this.pgsReadinessRating,
//     this.isDeleted, {
//     this.remarks,
//     this.rowVersion,
//   });

//   factory PerformanceGovernanceSystem.fromJson(Map<String, dynamic> json) =>
//       _$PerformanceGovernanceSystemFromJson(json);
//   Map<String, dynamic> toJson() => _$PerformanceGovernanceSystemToJson(this);
// }
@JsonSerializable()
class PerformanceGovernanceSystem {
  final int id;

  @JsonKey()
  final Office office;

  @JsonKey()
  PgsPeriod pgsPeriod;

  @JsonKey(defaultValue: '')
  final String? remarks;

  @JsonKey()
  List<PgsDeliverables> pgsDeliverables;

  @JsonKey()
  final PgsReadiness pgsReadinessRating;

  @JsonKey()
  final List<PgsSignatory>? pgsSignatories;

  final bool isDeleted;
  final String? rowVersion;
  final double percentDeliverables;
  final String? pgsStatus;

  PerformanceGovernanceSystem({
    required this.id,
    required this.office,
    required this.pgsPeriod,
    required this.pgsDeliverables,
    required this.pgsReadinessRating,
    required this.pgsSignatories,
    required this.isDeleted,
    this.remarks,
    this.rowVersion,
    required this.percentDeliverables,
    required this.pgsStatus,
  });

  factory PerformanceGovernanceSystem.fromJson(Map<String, dynamic> json) =>
      _$PerformanceGovernanceSystemFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceGovernanceSystemToJson(this);
}
