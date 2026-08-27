import 'package:json_annotation/json_annotation.dart';

part 'pvt_deliverable_findings.g.dart';

@JsonSerializable()
class PvtDeliverableFindings {
  int id;
  bool? isDeleted;
  String? rowVersion;
  int performanceValidationToolId;
  int pgsDeliverableId;
  String? deliverableName;
  String? findings;
  bool? isNC;
  bool? isOFI;
  DateTime? postingDate;

  PvtDeliverableFindings(
    this.id,
    this.isDeleted,
    this.performanceValidationToolId,
    this.pgsDeliverableId, {
    this.rowVersion,
    this.deliverableName,
    this.findings,
    this.isNC,
    this.isOFI,
    this.postingDate,
  });

  factory PvtDeliverableFindings.fromJson(Map<String, dynamic> json) =>
      _$PvtDeliverableFindingsFromJson(json);

  Map<String, dynamic> toJson() => _$PvtDeliverableFindingsToJson(this);
}
