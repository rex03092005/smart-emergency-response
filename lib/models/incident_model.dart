import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

part 'incident_model.g.dart';

@HiveType(typeId: 0)
enum IncidentCategory {
  @HiveField(0) medical,
  @HiveField(1) fire,
  @HiveField(2) security,
  @HiveField(3) natural,
  @HiveField(4) infrastructure,
  @HiveField(5) other
}

@HiveType(typeId: 1)
enum IncidentPriority {
  @HiveField(0) low,
  @HiveField(1) medium,
  @HiveField(2) high,
  @HiveField(3) critical
}

@HiveType(typeId: 2)
enum IncidentStatus {
  @HiveField(0) reported,
  @HiveField(1) inProgress,
  @HiveField(2) resolved,
  @HiveField(3) closed
}

@HiveType(typeId: 3)
class IncidentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final IncidentCategory category;

  @HiveField(4)
  final IncidentPriority priority;

  @HiveField(5)
  final IncidentStatus status;

  @HiveField(6)
  final String location;

  @HiveField(7)
  final double? latitude;

  @HiveField(8)
  final double? longitude;

  @HiveField(9)
  final DateTime reportedAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final String? assignedResponder;

  @HiveField(12)
  final String reportedBy;

  @HiveField(13)
  final bool isSynced;

  @HiveField(14)
  final List<String> notes;

  IncidentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.location,
    this.latitude,
    this.longitude,
    required this.reportedAt,
    required this.updatedAt,
    this.assignedResponder,
    this.reportedBy = "Anonymous User",
    this.isSynced = false,
    required this.notes,
  });

  factory IncidentModel.create({
    required String title,
    required String description,
    required IncidentCategory category,
    required IncidentPriority priority,
    required String location,
    double? latitude,
    double? longitude,
    String reportedBy = "Anonymous User",
  }) {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(now);
    final uuid = const Uuid().v4().substring(0, 4).toUpperCase();
    final id = "INC-$dateStr-$uuid";

    return IncidentModel(
      id: id,
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: IncidentStatus.reported,
      location: location,
      latitude: latitude,
      longitude: longitude,
      reportedAt: now,
      updatedAt: now,
      reportedBy: reportedBy,
      isSynced: false,
      notes: [],
    );
  }

  IncidentModel copyWith({
    String? title,
    String? description,
    IncidentCategory? category,
    IncidentPriority? priority,
    IncidentStatus? status,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? reportedAt,
    DateTime? updatedAt,
    String? assignedResponder,
    String? reportedBy,
    bool? isSynced,
    List<String>? notes,
  }) {
    return IncidentModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reportedAt: reportedAt ?? this.reportedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedResponder: assignedResponder ?? this.assignedResponder,
      reportedBy: reportedBy ?? this.reportedBy,
      isSynced: isSynced ?? this.isSynced,
      notes: notes ?? List.from(this.notes),
    );
  }
}
