import 'package:imis/standard_version/models/standard_version.dart';
import 'package:json_annotation/json_annotation.dart';

part 'iso_standard.g.dart';

@JsonSerializable()
class IsoStandard {

  final int id;
  final int? parentID;
  final int versionID;
  final StandardVersion? version;
  final String particulars;
  final String clauseRef;
  final String? description;
  final String? rowVersion;
  final bool? isDeleted;
  final bool isActive;
  final List<IsoStandard>? children;

  IsoStandard({
    required this.id,
    this.parentID,
    required this.versionID,
    this.version,
    required this.particulars,
    required this.clauseRef,
    this.description,
    this.rowVersion,
    this.isDeleted = false,
    this.isActive = true,
    this.children,
  }); 

  factory IsoStandard.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardToJson(this);
}
