import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'isat_period.g.dart';

@JsonSerializable()
class IsatPeriod {
  int id;
  bool isDeleted;

  @DateTimeConverter()
  DateTime startDate;

  @DateTimeConverter()
  DateTime endDate;

  String? rowVersion;
  String? remarks;
  bool? isActive;

  IsatPeriod(
    this.id,
    this.isDeleted,
    this.startDate,
    this.endDate,
    this.remarks, {
    this.rowVersion,
    this.isActive,
  });

  factory IsatPeriod.fromJson(Map<String, dynamic> json) =>
      _$IsatPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$IsatPeriodToJson(this);
}
