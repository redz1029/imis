import 'package:json_annotation/json_annotation.dart';

part 'pap_history_log.g.dart';

@JsonSerializable(explicitToJson: true)
class PapHistoryLog {
  int? id;
  bool? isDeleted;
  String? rowVersion;

  int policyAndProcedureId;
  String titleName;

  @JsonKey(name: 'date')
  DateTime? effectiveDate;

  @JsonKey(defaultValue: [])
  List<PolicyandProceduresLogList> policyAndProcedureLogList;

  PapHistoryLog({
    this.id,
    this.isDeleted,
    this.rowVersion,
    required this.policyAndProcedureId,
    required this.titleName,
    this.effectiveDate,
    this.policyAndProcedureLogList = const [],
  });

  factory PapHistoryLog.fromJson(Map<String, dynamic> json) =>
      _$PapHistoryLogFromJson(json);

  Map<String, dynamic> toJson() => _$PapHistoryLogToJson(this);
}

@JsonSerializable()
class PolicyandProceduresLogList {
  int? id;
  bool? isDeleted;
  String? rowVersion;

  int? policyAndProcedureHistoryLogId;
  String? documentCode;
  String? pageNo;
  String? revision;
  DateTime? date;
  String? reasons;

  PolicyandProceduresLogList({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.policyAndProcedureHistoryLogId,
    this.documentCode,
    this.pageNo,
    this.revision,
    this.date,
    this.reasons,
  });

  factory PolicyandProceduresLogList.fromJson(Map<String, dynamic> json) =>
      _$PolicyandProceduresLogListFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyandProceduresLogListToJson(this);
}
