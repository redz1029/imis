import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'isat_strategic_contribution.g.dart';

@JsonSerializable()
class IsatStrategicContribution {
  int id;
  bool isDeleted;
  String? rowVersion;
  int isatId;
  int pgsDeliverableId;
  String? pgsDeliverableName;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  IsatStrategicContribution(
    this.id,
    this.isDeleted,
    this.isatId,
    this.pgsDeliverableId,
    this.postingDate,
    this.pgsDeliverableName, {
    this.rowVersion,
  });

  factory IsatStrategicContribution.fromJson(Map<String, dynamic> json) =>
      _$IsatStrategicContributionFromJson(json);

  Map<String, dynamic> toJson() => _$IsatStrategicContributionToJson(this);
}
