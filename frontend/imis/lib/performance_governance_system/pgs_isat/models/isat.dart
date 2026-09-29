import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_isat/isat_signatory_template/models/isat_signatory.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_annual_performance_commitments.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_strategic_contribution.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_strategic_objective_supported.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'isat.g.dart';

@JsonSerializable()
class Isat {
  int id;
  int isatPeriodId;
  PgsPeriod? isatPeriod;
  Office? office;
  String employeeUserId;
  int officeId;
  List<IsatStrategicObjectiveSupported> isatStrategicObjectiveSupported;
  List<IsatStrategicContribution> isatStrategyContribution;
  List<IsatAnnualPerformanceCommitments> isatAnnualPerformanceCommitments;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;
  bool isDeleted;
  bool? isDraft;
  List<IsatSignatory>? isatSignatories;
  String? rowVersion;

  Isat(
    this.id,
    this.isatPeriodId,
    this.employeeUserId,
    this.officeId,
    this.isatStrategicObjectiveSupported,
    this.isatAnnualPerformanceCommitments,
    this.isatStrategyContribution,
    this.postingDate,
    this.isDraft,
    this.isDeleted,
    this.isatSignatories, {
    this.rowVersion,
    this.office,
    this.isatPeriod,
  });
  factory Isat.fromJson(Map<String, dynamic> json) => _$IsatFromJson(json);

  Map<String, dynamic> toJson() => _$IsatToJson(this);
}
