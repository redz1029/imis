import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roadmap_history.g.dart';

@JsonSerializable()
class RoadmapHistory {
  String? kraDescription;
  int? year;
  String? deliverableDescription;
  String? kraRoadmapName;

  @JsonKey()
  @IsoDateTimeConverter()
  DateTime? postingDate;

  String? userFullName;
  bool? isDeleted;
  String? rowVersion;

  RoadmapHistory({
    this.kraDescription,
    this.year,
    this.deliverableDescription,
    this.kraRoadmapName,
    this.postingDate,
    this.userFullName,
    this.isDeleted,
    this.rowVersion,
  });

  factory RoadmapHistory.fromJson(Map<String, dynamic> json) =>
      _$RoadmapHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapHistoryToJson(this);
}
