import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'isat_strategic_objective_supported.g.dart';

@JsonSerializable()
class IsatStrategicObjectiveSupported {
  int id;
  int isatId;
  int kraRoadMapId;
  String kraName;
  int kraRoadMapDeliverableId;
  String kraRoadMapDeliverableName;
  String strategicObjective;

  @JsonKey()
  @DateTimeConverter()
  DateTime? postingDate;

  bool isDeleted;
  String? rowVersion;

  IsatStrategicObjectiveSupported(
    this.id,
    this.isatId,
    this.kraRoadMapId,
    this.kraName,
    this.kraRoadMapDeliverableId,
    this.kraRoadMapDeliverableName,
    this.strategicObjective,
    this.postingDate,
    this.isDeleted, {
    this.rowVersion,
  });

  factory IsatStrategicObjectiveSupported.fromJson(Map<String, dynamic> json) =>
      _$IsatStrategicObjectiveSupportedFromJson(json);

  Map<String, dynamic> toJson() =>
      _$IsatStrategicObjectiveSupportedToJson(this);
}
