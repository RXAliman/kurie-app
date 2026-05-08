// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DisputeAdapter extends TypeAdapter<Dispute> {
  @override
  final typeId = 4;

  @override
  Dispute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dispute(
      id: fields[0] as String,
      submeterId: fields[1] as String,
      tenantName: fields[2] as String,
      billCycle: fields[3] as String,
      amount: (fields[4] as num).toDouble(),
      usage: (fields[5] as num).toDouble(),
      status: fields[6] as String,
      timestamp: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Dispute obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.submeterId)
      ..writeByte(2)
      ..write(obj.tenantName)
      ..writeByte(3)
      ..write(obj.billCycle)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.usage)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisputeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
