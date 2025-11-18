import 'package:flutter/foundation.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'swot.g.dart';

@JsonSerializable()
class Swot {
  int id;
  bool? isDeleted;
  String? rowVersion;
  String userId;
  String strengths;
  String weaknesses;
  String opportunities;
  String threats;
  String longTermDepartmentStrategicPlan;
  String immediateNeedsToAchieveVision;
  String departmentAchievementsAndBestPractices;

  @JsonKey()
  @DateTimeConverter()
  DateTime postingDate;

  Swot(
    this.id,
    this.userId,
    this.strengths,
    this.weaknesses,
    this.opportunities,
    this.threats,
    this.longTermDepartmentStrategicPlan,
    this.immediateNeedsToAchieveVision,
    this.departmentAchievementsAndBestPractices,
    this.isDeleted,
    this.postingDate, {
    this.rowVersion,
  });
  factory Swot.fromJson(Map<String, dynamic> json) => _$SwotFromJson(json);
  Map<String, dynamic> toJson() => _$SwotToJson(this);
}
