// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryAdapter extends TypeAdapter<Library> {
  @override
  final int typeId = 4;

  @override
  Library read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Library(
      name: fields[0] as String,
      books: (fields[1] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, Library obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.books);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
