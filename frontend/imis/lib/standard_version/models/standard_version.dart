import 'package:json_annotation/json_annotation.dart';

part 'standard_version.g.dart';

@JsonSerializable()
class StandardVersion {
  final int id;
  final String versionName;
  final bool isActive;
  final String? rowVersion;
  final bool? isDeleted;

  StandardVersion({
    required this.id,
    required this.versionName,
    required this.isActive,
    this.rowVersion,
    this.isDeleted,
  });

  factory StandardVersion.fromJson(Map<String, dynamic> json) =>
      _$StandardVersionFromJson(json);

  Map<String, dynamic> toJson() => _$StandardVersionToJson(this);
}
