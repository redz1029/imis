import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final int id;
  final String title;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isActive;
  final String? rowVersion;
  final bool? isDeleted;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
    this.rowVersion,
    this.isDeleted,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
