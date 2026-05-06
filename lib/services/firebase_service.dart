import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident_model.dart';
import '../models/responder_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Incidents ---

  static Future<void> saveIncident(IncidentModel incident) async {
    // Add or update the incident in the 'incidents' collection
    await _firestore.collection('incidents').doc(incident.id).set({
      'id': incident.id,
      'title': incident.title,
      'description': incident.description,
      'location': incident.location,
      'category': incident.category.index,
      'priority': incident.priority.index,
      'status': incident.status.index,
      'reportedAt': incident.reportedAt.toIso8601String(),
      'updatedAt': incident.updatedAt.toIso8601String(),
      'reportedBy': incident.reportedBy,
      'assignedResponder': incident.assignedResponder,
      'notes': incident.notes,
    }, SetOptions(merge: true));
  }

  static Future<List<IncidentModel>> getIncidents() async {
    final snapshot = await _firestore.collection('incidents').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return IncidentModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        location: data['location'],
        category: IncidentCategory.values[data['category'] as int],
        priority: IncidentPriority.values[data['priority'] as int],
        status: IncidentStatus.values[data['status'] as int],
        reportedAt: DateTime.parse(data['reportedAt']),
        updatedAt: DateTime.parse(data['updatedAt']),
        reportedBy: data['reportedBy'],
        assignedResponder: data['assignedResponder'],
        notes: List<String>.from(data['notes'] ?? []),
        isSynced: true, // Data coming from Firebase is inherently synced
      );
    }).toList();
  }

  // --- Responders ---

  static Future<void> saveResponder(ResponderModel responder) async {
    await _firestore.collection('responders').doc(responder.id).set({
      'id': responder.id,
      'name': responder.name,
      'role': responder.role,
      'isAvailable': responder.isAvailable,
    }, SetOptions(merge: true));
  }

  static Future<List<ResponderModel>> getResponders() async {
    final snapshot = await _firestore.collection('responders').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ResponderModel(
        id: data['id'],
        name: data['name'],
        role: data['role'],
        isAvailable: data['isAvailable'],
      );
    }).toList();
  }
}
