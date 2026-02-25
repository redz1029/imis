import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'score_card_monitoring_accomplishment.g.dart';

@JsonSerializable()
class ScoreCardMonitoringAccomplishment {
  int id;
  int? kraRoadMapDeliverableId;

  @JsonKey()
  @DateTimeConverter()
  DateTime postingDate;
  String? userId;
  int? percentAccomplished;
  String? remarks;
  String? attachmentPath;
  final bool? isDeleted;
  final String? rowVersion;

  ScoreCardMonitoringAccomplishment(
    this.id,
    this.kraRoadMapDeliverableId,
    this.postingDate,
    this.userId,
    this.percentAccomplished,
    this.remarks,
    this.attachmentPath, {
    this.isDeleted,
    this.rowVersion,
  });

  factory ScoreCardMonitoringAccomplishment.fromJson(
    Map<String, dynamic> json,
  ) => _$ScoreCardMonitoringAccomplishmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScoreCardMonitoringAccomplishmentToJson(this);
}
