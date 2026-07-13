import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performance_validation_tool_period.g.dart';

@JsonSerializable()
class PerformanceValidationToolPeriod {
  int id;
  bool isDeleted;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;
  String? period;
  String? rowVersion;

  PerformanceValidationToolPeriod(
    this.id,
    this.isDeleted,
    this.startDate,
    this.endDate, {
    this.period,
    this.rowVersion,
  });

  factory PerformanceValidationToolPeriod.fromJson(Map<String, dynamic> json) =>
      _$PerformanceValidationToolPeriodFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PerformanceValidationToolPeriodToJson(this);
}
