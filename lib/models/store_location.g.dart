// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreLocationAdapter extends TypeAdapter<StoreLocation> {
  @override
  final int typeId = 3;

  @override
  StoreLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreLocation(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StoreLocation obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
