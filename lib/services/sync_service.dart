import 'hive_service.dart';
import 'firebase_service.dart';
import '../models/incident_model.dart';

class SyncService {
  static Future<int> syncOfflineData() async {
    final box = HiveService.getIncidentBox();
    final unsynced = box.values.where((incident) => !incident.isSynced).toList();
    
    if (unsynced.isEmpty) return 0;

    int syncedCount = 0;
    for (var incident in unsynced) {
      try {
        // Upload to Firebase
        await FirebaseService.saveIncident(incident);
        
        // Update local storage to mark as synced
        final syncedIncident = incident.copyWith(isSynced: true);
        await box.put(incident.id, syncedIncident);
        syncedCount++;
      } catch (e) {
        print('Error syncing incident ${incident.id}: $e');
      }
    }
    
    return syncedCount;
  }
}
