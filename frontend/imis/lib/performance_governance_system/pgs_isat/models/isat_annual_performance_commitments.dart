import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'isat_annual_performance_commitments.g.dart';

@JsonSerializable()
class IsatAnnualPerformanceCommitments {
  int id;
  bool isDeleted;
  String? rowVersion;
  int isatId;
  String? deliverable;
  String? target;
  String? accomplishment;
  int? kraId;
  String? kraMName;
  int? pgsDeliverableId;
  String? deliverableMName;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  IsatAnnualPerformanceCommitments(
    this.id,
    this.isatId,
    this.deliverable,
    this.target,
    this.accomplishment,
    this.isDeleted,
    this.postingDate, {
    this.rowVersion,
    this.kraId,
    this.kraMName,
    this.pgsDeliverableId,
    this.deliverableMName,
  });

  factory IsatAnnualPerformanceCommitments.fromJson(
    Map<String, dynamic> json,
  ) => _$IsatAnnualPerformanceCommitmentsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$IsatAnnualPerformanceCommitmentsToJson(this);
}
