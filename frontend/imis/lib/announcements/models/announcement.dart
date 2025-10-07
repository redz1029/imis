import 'package:json_annotation/json_annotation.dart';
part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  int id;
  final String title;
  final DateTime toDate;
  final DateTime fromDateDate;
  final String description;
  final bool isActive;
  String? rowVersion;
  bool? isDeleted;

  Announcement({
    required this.id,
    required this.title,
    required this.toDate,
    required this.description,
    required this.fromDateDate,
    required this.isActive,
    this.rowVersion,
    this.isDeleted,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
