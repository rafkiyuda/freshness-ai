import 'package:hive/hive.dart';


part 'qc_session.g.dart';

@HiveType(typeId: 0)
class QcSession extends HiveObject {
  @HiveField(0)
  final String qcSessionId;
  
  @HiveField(1)
  final String skuId;
  
  @HiveField(2)
  final String skuName;
  
  @HiveField(3)
  final String supplierId;
  
  @HiveField(4)
  final String supplierName;
  
  @HiveField(5)
  final int freshnessScore;
  
  @HiveField(6)
  final String freshnessStatus;
  
  @HiveField(7)
  final int confidenceScore;
  
  @HiveField(8)
  final String aiRecommendation;
  
  @HiveField(9)
  final String staffDecision;
  
  @HiveField(10)
  String status;
  
  @HiveField(11)
  final String? imageEvidenceUrl;
  
  @HiveField(12)
  final String? localImagePath;
  
  @HiveField(13)
  final String? notes;
  
  @HiveField(14)
  final DateTime checkedAt;
  
  @HiveField(15)
  final String checkedBy;
  
  @HiveField(16)
  DateTime? syncedAt;

  QcSession({
    required this.qcSessionId,
    required this.skuId,
    required this.skuName,
    required this.supplierId,
    required this.supplierName,
    required this.freshnessScore,
    required this.freshnessStatus,
    required this.confidenceScore,
    required this.aiRecommendation,
    required this.staffDecision,
    required this.status,
    this.imageEvidenceUrl,
    this.localImagePath,
    this.notes,
    required this.checkedAt,
    required this.checkedBy,
    this.syncedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'qcSessionId': qcSessionId,
      'skuId': skuId,
      'skuName': skuName,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'freshnessScore': freshnessScore,
      'freshnessStatus': freshnessStatus,
      'confidenceScore': confidenceScore,
      'aiRecommendation': aiRecommendation,
      'staffDecision': staffDecision,
      'status': status,
      'imageEvidenceUrl': imageEvidenceUrl,
      'notes': notes,
      'checkedAt': checkedAt.toIso8601String(),
      'checkedBy': checkedBy,
    };
  }
}
