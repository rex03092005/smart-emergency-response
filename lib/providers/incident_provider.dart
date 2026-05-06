import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/incident_model.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';
import '../core/utils/priority_helper.dart';

class IncidentNotifier extends StateNotifier<List<IncidentModel>> {
  IncidentNotifier() : super([]) {
    _loadIncidents();
  }

  void _loadIncidents() {
    final box = HiveService.getIncidentBox();
    _updateState(box.values.toList());
  }

  void _updateState(List<IncidentModel> incidents) {
    incidents.sort((a, b) {
      final weightA = PriorityHelper.getPriorityWeight(a.priority);
      final weightB = PriorityHelper.getPriorityWeight(b.priority);
      if (weightA != weightB) {
        return weightB.compareTo(weightA); // Descending priority
      }
      return a.reportedAt.compareTo(b.reportedAt); // Ascending time (older critical cases first)
    });
    state = incidents;
  }

  Future<void> addIncident(IncidentModel incident) async {
    final box = HiveService.getIncidentBox();
    await box.put(incident.id, incident);
    
    if (incident.priority == IncidentPriority.critical) {
      await NotificationService.showCriticalAlert(
        title: "CRITICAL INCIDENT: ${incident.title}",
        body: incident.description,
      );
    }
    
    _loadIncidents();
    // Attempt to sync immediately
    await SyncService.syncOfflineData();
  }

  Future<void> updateIncident(IncidentModel incident) async {
    final box = HiveService.getIncidentBox();
    await box.put(incident.id, incident);
    _loadIncidents();
    await SyncService.syncOfflineData();
  }

  Future<void> deleteIncident(String id) async {
    final box = HiveService.getIncidentBox();
    await box.delete(id);
    _loadIncidents();
  }

  Future<void> markAllResolved() async {
    final box = HiveService.getIncidentBox();
    final now = DateTime.now();
    for (var incident in state) {
      if (incident.status != IncidentStatus.resolved && incident.status != IncidentStatus.closed) {
        final updated = incident.copyWith(
          status: IncidentStatus.resolved,
          updatedAt: now,
          isSynced: false,
          notes: [...incident.notes, "${now.toIso8601String()}: Marked as resolved via bulk action."],
        );
        await box.put(incident.id, updated);
      }
    }
    _loadIncidents();
    await SyncService.syncOfflineData();
  }
}

final incidentProvider = StateNotifierProvider<IncidentNotifier, List<IncidentModel>>((ref) {
  return IncidentNotifier();
});

final incidentByIdProvider = Provider.family<IncidentModel?, String>((ref, id) {
  final incidents = ref.watch(incidentProvider);
  try {
    return incidents.firstWhere((element) => element.id == id);
  } catch (e) {
    return null;
  }
});
