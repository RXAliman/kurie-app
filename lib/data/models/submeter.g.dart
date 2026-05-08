// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submeter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubmeterAdapter extends TypeAdapter<Submeter> {
  @override
  final typeId = 0;

  @override
  Submeter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Submeter(
      id: fields[0] as String,
      name: fields[1] as String,
      unit: fields[2] as String,
      tenantId: fields[3] as String,
      lastReading: fields[4] as String,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Submeter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.tenantId)
      ..writeByte(4)
      ..write(obj.lastReading)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmeterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
