// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncidentModelAdapter extends TypeAdapter<IncidentModel> {
  @override
  final int typeId = 3;

  @override
  IncidentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncidentModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as IncidentCategory,
      priority: fields[4] as IncidentPriority,
      status: fields[5] as IncidentStatus,
      location: fields[6] as String,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
      reportedAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      assignedResponder: fields[11] as String?,
      reportedBy: fields[12] as String,
      isSynced: fields[13] as bool,
      notes: (fields[14] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, IncidentModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.reportedAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.assignedResponder)
      ..writeByte(12)
      ..write(obj.reportedBy)
      ..writeByte(13)
      ..write(obj.isSynced)
      ..writeByte(14)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncidentCategoryAdapter extends TypeAdapter<IncidentCategory> {
  @override
  final int typeId = 0;

  @override
  IncidentCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncidentCategory.medical;
      case 1:
        return IncidentCategory.fire;
      case 2:
        return IncidentCategory.security;
      case 3:
        return IncidentCategory.natural;
      case 4:
        return IncidentCategory.infrastructure;
      case 5:
        return IncidentCategory.other;
      default:
        return IncidentCategory.medical;
    }
  }

  @override
  void write(BinaryWriter writer, IncidentCategory obj) {
    switch (obj) {
      case IncidentCategory.medical:
        writer.writeByte(0);
        break;
      case IncidentCategory.fire:
        writer.writeByte(1);
        break;
      case IncidentCategory.security:
        writer.writeByte(2);
        break;
      case IncidentCategory.natural:
        writer.writeByte(3);
        break;
      case IncidentCategory.infrastructure:
        writer.writeByte(4);
        break;
      case IncidentCategory.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncidentPriorityAdapter extends TypeAdapter<IncidentPriority> {
  @override
  final int typeId = 1;

  @override
  IncidentPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncidentPriority.low;
      case 1:
        return IncidentPriority.medium;
      case 2:
        return IncidentPriority.high;
      case 3:
        return IncidentPriority.critical;
      default:
        return IncidentPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, IncidentPriority obj) {
    switch (obj) {
      case IncidentPriority.low:
        writer.writeByte(0);
        break;
      case IncidentPriority.medium:
        writer.writeByte(1);
        break;
      case IncidentPriority.high:
        writer.writeByte(2);
        break;
      case IncidentPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncidentStatusAdapter extends TypeAdapter<IncidentStatus> {
  @override
  final int typeId = 2;

  @override
  IncidentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncidentStatus.reported;
      case 1:
        return IncidentStatus.inProgress;
      case 2:
        return IncidentStatus.resolved;
      case 3:
        return IncidentStatus.closed;
      default:
        return IncidentStatus.reported;
    }
  }

  @override
  void write(BinaryWriter writer, IncidentStatus obj) {
    switch (obj) {
      case IncidentStatus.reported:
        writer.writeByte(0);
        break;
      case IncidentStatus.inProgress:
        writer.writeByte(1);
        break;
      case IncidentStatus.resolved:
        writer.writeByte(2);
        break;
      case IncidentStatus.closed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
