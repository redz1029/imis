import 'package:json_annotation/json_annotation.dart';

part 'score_card_monitoring_filter.g.dart';

@JsonSerializable()
class ScoreCardMonitoringFilter {
  int? kraid;
  int? year;

  ScoreCardMonitoringFilter(this.kraid, this.year);

  factory ScoreCardMonitoringFilter.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardMonitoringFilterFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreCardMonitoringFilterToJson(this);
}
