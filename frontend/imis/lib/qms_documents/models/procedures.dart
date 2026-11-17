import 'package:imis/qms_documents/models/pap_signatory.dart';
import 'package:json_annotation/json_annotation.dart';
part 'procedures.g.dart';

@JsonSerializable(explicitToJson: true)
class Procedures {
  int? id;
  bool isDeleted;
  String? rowVersion;
  String? title;
  String? processOwner;
  String? regulatoryStandard;
  DateTime? effectiveDate;
  int? sectionId;
  String? officeName;
  String? documentCode;
  String? revision;
  String? content;
  bool? isMasterCopy;
  bool? isControlledCopy;
  @JsonKey(includeToJson: false, includeFromJson: true)
  String? minutesAttachmentPath;

  bool? removeAttachment;
  List<PapSignatory>? papSignatories;
  bool? isDraft;
  bool? forSignature;

  Procedures({
    this.id,
    required this.isDeleted,
    this.rowVersion,
    this.title,
    this.processOwner,
    this.regulatoryStandard,
    this.effectiveDate,
    this.sectionId,
    this.officeName,
    this.documentCode,
    this.revision,
    this.content,
    this.isMasterCopy,
    this.isControlledCopy,
    this.minutesAttachmentPath,
    this.removeAttachment,
    this.papSignatories,
    this.isDraft,
    this.forSignature,
  });

  factory Procedures.fromJson(Map<String, dynamic> json) =>
      _$ProceduresFromJson(json);

  Map<String, dynamic> toJson() => _$ProceduresToJson(this);
}
