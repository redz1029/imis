import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'osm_calendar_activity.g.dart';

@JsonSerializable()
class OsmCalendarActivity {
  int id;
  String title;
  String? description;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;
  String? startTime;
  String? endTime;
  bool? isAllDay;
  String? color;
  String? category;
  String? location;
  int? status;
  String? userId;
  String? userFullName;
  int? officeId;
  String? officeName;
  int? reminderMinutes;
  String? meetingLink;

  String? attachmentPath;

  OsmCalendarActivity(
    this.id,
    this.title,
    this.startDate, {
    this.description,
    this.isAllDay,
    this.startTime,
    this.endTime,
    this.color,
    this.category,
    this.location,
    this.status,
    this.userId,
    this.userFullName,
    this.officeId,
    this.officeName,
    this.reminderMinutes,
    this.meetingLink,
    this.attachmentPath,
  });

  factory OsmCalendarActivity.fromJson(Map<String, dynamic> json) =>
      _$OsmCalendarActivityFromJson(json);

  Map<String, dynamic> toJson() => _$OsmCalendarActivityToJson(this);
}
