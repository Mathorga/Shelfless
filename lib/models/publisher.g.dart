// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PublisherAdapter extends TypeAdapter<Publisher> {
  @override
  final int typeId = 3;

  @override
  Publisher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Publisher(
      name: fields[0] as String,
      website: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Publisher obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublisherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
