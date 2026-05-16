// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadingAdapter extends TypeAdapter<Reading> {
  @override
  final typeId = 1;

  @override
  Reading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reading(
      id: fields[0] as String,
      submeterId: fields[1] as String,
      value: (fields[2] as num).toDouble(),
      timestamp: fields[3] as DateTime,
      balance: fields[5] == null ? 0.0 : (fields[5] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Reading obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.submeterId)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
