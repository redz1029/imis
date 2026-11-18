import 'package:json_annotation/json_annotation.dart';

part 'pap_dcrrf_history.g.dart';

@JsonSerializable(explicitToJson: true)
class PapDcrrfHistory {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  List<PapDcrrfHistoryLog>? policyAndProcedureLogList;

  PapDcrrfHistory({
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.policyAndProcedureLogList,
  });

  factory PapDcrrfHistory.fromJson(Map<String, dynamic> json) =>
      _$PapDcrrfHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PapDcrrfHistoryToJson(this);
}

@JsonSerializable()
class PapDcrrfHistoryLog {
  int? id;

  bool? isDeleted;

  String? rowVersion;

  int? policyAndProcedureHistoryLogId;

  String? documentCode;

  String? pageNo;

  String? revision;

  DateTime? date;

  String? reasons;

  PapDcrrfHistoryLog({
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

  factory PapDcrrfHistoryLog.fromJson(Map<String, dynamic> json) =>
      _$PapDcrrfHistoryLogFromJson(json);

  Map<String, dynamic> toJson() => _$PapDcrrfHistoryLogToJson(this);
}
