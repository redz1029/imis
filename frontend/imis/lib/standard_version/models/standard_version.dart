import 'package:json_annotation/json_annotation.dart';

part 'standard_version.g.dart';

@JsonSerializable()
class StandardVersion {
  final int id;
  final String versionName;
  final List<dynamic>? isoStandards;
  final String? rowVersion;
  final bool? isDeleted;
  final bool isActive;

  StandardVersion({
    required this.id,
    required this.versionName,
    this.isoStandards,
    this.rowVersion,
    this.isDeleted,
    this.isActive = true,
  });

  factory StandardVersion.fromJson(Map<String, dynamic> json) =>
      _$StandardVersionFromJson(json);

  Map<String, dynamic> toJson() => _$StandardVersionToJson(this);
}
