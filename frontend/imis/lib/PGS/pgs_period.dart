import 'package:json_annotation/json_annotation.dart';

part 'pgs_period.g.dart';

@JsonSerializable()
class PgsPeriod {
  int id;
  DateTime startDate;
  DateTime endDate;

  PgsPeriod(this.id, this.startDate, this.endDate);

  factory PgsPeriod.fromJson(Map<String, dynamic> json) =>
      _$PgsPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PgsPeriodToJson(this);
}
