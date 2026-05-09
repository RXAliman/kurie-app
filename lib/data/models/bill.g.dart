// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final typeId = 2;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      id: fields[0] as String,
      submeterId: fields[1] as String,
      month: fields[2] as String,
      amount: (fields[3] as num).toDouble(),
      kwh: (fields[4] as num).toDouble(),
      status: fields[5] as String,
      timestamp: fields[6] as DateTime,
      previousReading: (fields[7] as num?)?.toDouble(),
      currentReading: (fields[8] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.submeterId)
      ..writeByte(2)
      ..write(obj.month)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.kwh)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.previousReading)
      ..writeByte(8)
      ..write(obj.currentReading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
