import 'package:json_annotation/json_annotation.dart';
part 'auditor.g.dart';

@JsonSerializable()
class Auditor {
  int? id;
  bool isDeleted;
  String? rowVersion;
  bool isActive;
  String? userId;

  Auditor({
    required this.id,
    this.isDeleted = false,
    this.rowVersion,
    this.isActive = true,
    required this.userId,
  });

  factory Auditor.fromJson(Map<String, dynamic> json) =>
      _$AuditorFromJson(json);

  Map<String, dynamic> toJson() => _$AuditorToJson(this);
}
