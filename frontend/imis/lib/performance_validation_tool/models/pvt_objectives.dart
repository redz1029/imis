import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pvt_objectives.g.dart';

@JsonSerializable()
class PvtObjectives {
  int id;
  bool? isDeleted;
  String? rowVersion;
  int performanceValidationToolId;
  bool? isAssessmentCompliant;
  bool? isImplementationVerified;
  bool? isDeliverableProgressMonitored;
  bool? hasOpportunitiesForImprovement;
  bool? isValidated;

  @DateTimeConverter()
  DateTime? postingDate;

  PvtObjectives(
    this.id,
    this.performanceValidationToolId, {
    this.isDeleted,
    this.rowVersion,
    this.isAssessmentCompliant,
    this.isImplementationVerified,
    this.isDeliverableProgressMonitored,
    this.hasOpportunitiesForImprovement,
    this.isValidated,
    this.postingDate,
  });

  factory PvtObjectives.fromJson(Map<String, dynamic> json) =>
      _$PvtObjectivesFromJson(json);

  Map<String, dynamic> toJson() => _$PvtObjectivesToJson(this);
}
