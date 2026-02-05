import 'package:imis/standard_version/models/standard_version.dart';
import 'package:json_annotation/json_annotation.dart';

part 'iso_standard.g.dart';

@JsonSerializable()
class IsoStandard {

  final int id;
  final int versionID;
  final String clauseRef;
  final String description;
  final String? rowVersion;
  final StandardVersion version;
  final bool? isDeleted;
  final bool isActive;

  IsoStandard({
    required this.id,
    required this.versionID,
    required this.clauseRef,
    required this.description,
    this.rowVersion,
    required this.version,
    this.isDeleted = false,
    this.isActive = true,
  }); 

  factory IsoStandard.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardToJson(this);
}
