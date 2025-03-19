import 'package:json_annotation/json_annotation.dart';

part 'pgs_period.g.dart';

@JsonSerializable()
class PgsPeriod {
  int id;

  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  DateTime startDate;

  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  DateTime endDate;

  String? rowVersion;

  PgsPeriod(this.id, this.startDate, this.endDate, this.rowVersion);

  factory PgsPeriod.fromJson(Map<String, dynamic> json) =>
      _$PgsPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PgsPeriodToJson(this);
}

// ✅ Define the functions outside the class
DateTime dateFromJson(String date) => DateTime.parse(date);
String dateToJson(DateTime date) =>
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
