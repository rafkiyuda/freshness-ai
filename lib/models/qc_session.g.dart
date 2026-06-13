// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QcSessionAdapter extends TypeAdapter<QcSession> {
  @override
  final int typeId = 0;

  @override
  QcSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QcSession(
      qcSessionId: fields[0] as String,
      skuId: fields[1] as String,
      skuName: fields[2] as String,
      supplierId: fields[3] as String,
      supplierName: fields[4] as String,
      freshnessScore: fields[5] as int,
      freshnessStatus: fields[6] as String,
      confidenceScore: fields[7] as int,
      aiRecommendation: fields[8] as String,
      staffDecision: fields[9] as String,
      status: fields[10] as String,
      imageEvidenceUrl: fields[11] as String?,
      localImagePath: fields[12] as String?,
      notes: fields[13] as String?,
      checkedAt: fields[14] as DateTime,
      checkedBy: fields[15] as String,
      syncedAt: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QcSession obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.qcSessionId)
      ..writeByte(1)
      ..write(obj.skuId)
      ..writeByte(2)
      ..write(obj.skuName)
      ..writeByte(3)
      ..write(obj.supplierId)
      ..writeByte(4)
      ..write(obj.supplierName)
      ..writeByte(5)
      ..write(obj.freshnessScore)
      ..writeByte(6)
      ..write(obj.freshnessStatus)
      ..writeByte(7)
      ..write(obj.confidenceScore)
      ..writeByte(8)
      ..write(obj.aiRecommendation)
      ..writeByte(9)
      ..write(obj.staffDecision)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.imageEvidenceUrl)
      ..writeByte(12)
      ..write(obj.localImagePath)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.checkedAt)
      ..writeByte(15)
      ..write(obj.checkedBy)
      ..writeByte(16)
      ..write(obj.syncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QcSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
