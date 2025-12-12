import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kra_roadmap_period.g.dart';

@JsonSerializable()
class KraRoadmapPeriod {
  int id;

  @JsonKey()
  @DateTimeConverter()
  DateTime startYear;

  @JsonKey()
  @DateTimeConverter()
  DateTime endYear;

  bool? isDeleted;
  String? rowVersion;

  KraRoadmapPeriod(
    this.id,
    this.startYear,
    this.endYear,
    this.isDeleted, {
    this.rowVersion,
  });

  factory KraRoadmapPeriod.fromJson(Map<String, dynamic> json) =>
      _$KraRoadmapPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$KraRoadmapPeriodToJson(this);
}
