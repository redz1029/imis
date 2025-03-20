import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pgs_period.g.dart';

@JsonSerializable()
class PgsPeriod {
  int id;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  String? rowVersion;

  PgsPeriod(this.id, this.startDate, this.endDate, {this.rowVersion});

  factory PgsPeriod.fromJson(Map<String, dynamic> json) =>
      _$PgsPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PgsPeriodToJson(this);
}
