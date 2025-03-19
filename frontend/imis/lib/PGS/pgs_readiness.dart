import 'package:json_annotation/json_annotation.dart';

part 'pgs_readiness.g.dart';

@JsonSerializable()
class PgsReadiness {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final double competenceToDeliver;
  final double resourceAvailability;
  final double confidenceToDeliver;
  final double totalScore;

  PgsReadiness(
      this.id,
      this.isDeleted,
      this.rowVersion,
      this.competenceToDeliver,
      this.resourceAvailability,
      this.confidenceToDeliver,
      this.totalScore);

  factory PgsReadiness.fromJson(Map<String, dynamic> json) =>
      _$PgsReadinessFromJson(json);

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isDeleted": isDeleted,
      "rowVersion": rowVersion,
      "competenceToDeliver": competenceToDeliver,
      "resourceAvailability": resourceAvailability,
      "confidenceToDeliver": confidenceToDeliver,
      "totalScore": totalScore,
    };
  }
}
