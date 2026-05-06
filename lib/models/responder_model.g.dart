// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponderModelAdapter extends TypeAdapter<ResponderModel> {
  @override
  final int typeId = 4;

  @override
  ResponderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponderModel(
      id: fields[0] as String,
      name: fields[1] as String,
      role: fields[2] as String,
      isAvailable: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ResponderModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.isAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
