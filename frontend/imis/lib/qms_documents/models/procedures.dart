import 'package:json_annotation/json_annotation.dart';
part 'procedures.g.dart';

@JsonSerializable()
class Procedures {
  int? id;
  String? title;
  String? processOwner;
  String? regulatoryStandard;
  DateTime? effectiveDate;
  int? sectionId;
  String? documentCode;
  String? revision;
  String? content;
  bool? isMasterCopy;
  bool? isControlledCopy;
  @JsonKey(includeToJson: false, includeFromJson: true)
  String? minutesAttachmentPath;

  bool? removeAttachment;

  Procedures({
    this.id,
    this.title,
    this.processOwner,
    this.regulatoryStandard,
    this.effectiveDate,
    this.sectionId,
    this.documentCode,
    this.revision,
    this.content,
    this.isMasterCopy,
    this.isControlledCopy,
    this.minutesAttachmentPath,
    this.removeAttachment,
  });

  factory Procedures.fromJson(Map<String, dynamic> json) =>
      _$ProceduresFromJson(json);

  Map<String, dynamic> toJson() => _$ProceduresToJson(this);
}
