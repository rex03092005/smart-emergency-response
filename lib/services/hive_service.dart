import 'package:hive_flutter/hive_flutter.dart';
import '../models/incident_model.dart';
import '../models/responder_model.dart';
import '../core/constants/app_constants.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(IncidentCategoryAdapter());
    Hive.registerAdapter(IncidentPriorityAdapter());
    Hive.registerAdapter(IncidentStatusAdapter());
    Hive.registerAdapter(IncidentModelAdapter());
    Hive.registerAdapter(ResponderModelAdapter());
    
    // Open Boxes
    await Hive.openBox<IncidentModel>(AppConstants.incidentBox);
    await Hive.openBox<ResponderModel>(AppConstants.responderBox);
    await Hive.openBox(AppConstants.settingsBox);
    
    // Seed Sample Data
    await _seedInitialData();
  }

  static Future<void> _seedInitialData() async {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final hasSeeded = settingsBox.get('hasSeededData', defaultValue: false);
    
    if (!hasSeeded) {
      final incidentBox = Hive.box<IncidentModel>(AppConstants.incidentBox);
      final responderBox = Hive.box<ResponderModel>(AppConstants.responderBox);
      
      // Sample Responders
      final responders = [
        ResponderModel(id: 'R1', name: 'Dr. Anjali Sharma', role: 'Medical'),
        ResponderModel(id: 'R2', name: 'Officer Ravi Kumar', role: 'Security'),
        ResponderModel(id: 'R3', name: 'Engineer Priya Mehta', role: 'Infrastructure'),
        ResponderModel(id: 'R4', name: 'Firefighter Arjun Singh', role: 'Fire'),
      ];
      
      for (var r in responders) {
        await responderBox.put(r.id, r);
      }
      
      // Sample Incidents
      final now = DateTime.now();
      final incidents = [
        IncidentModel.create(
          title: "Chemical Spill in Lab B3",
          description: "Hazardous chemical spill requires immediate attention.",
          category: IncidentCategory.fire,
          priority: IncidentPriority.critical,
          location: "Lab B3, North Wing",
        ).copyWith(
          status: IncidentStatus.inProgress,
          reportedAt: now.subtract(const Duration(hours: 3)),
          assignedResponder: 'R4'
        ),
        IncidentModel.create(
          title: "Student Injured on Stairs",
          description: "Student slipped and fell, might have a fracture.",
          category: IncidentCategory.medical,
          priority: IncidentPriority.high,
          location: "Main Building, Staircase A",
        ).copyWith(
          status: IncidentStatus.reported,
          reportedAt: now.subtract(const Duration(hours: 1)),
        ),
        IncidentModel.create(
          title: "Suspicious Person at Gate",
          description: "Unidentified person lingering near the back gate.",
          category: IncidentCategory.security,
          priority: IncidentPriority.medium,
          location: "Back Gate",
        ).copyWith(
          status: IncidentStatus.inProgress,
          reportedAt: now.subtract(const Duration(hours: 5)),
          assignedResponder: 'R2'
        ),
        IncidentModel.create(
          title: "Broken Street Light",
          description: "Street light flickering and went out.",
          category: IncidentCategory.infrastructure,
          priority: IncidentPriority.low,
          location: "Pathway C",
        ).copyWith(
          status: IncidentStatus.resolved,
          reportedAt: now.subtract(const Duration(days: 2)),
        ),
        IncidentModel.create(
          title: "Server Room Flooding",
          description: "Water leaking into the main server room.",
          category: IncidentCategory.infrastructure,
          priority: IncidentPriority.critical,
          location: "IT Block, Server Room",
        ).copyWith(
          status: IncidentStatus.reported,
          reportedAt: now.subtract(const Duration(minutes: 30)),
        ),
      ];
      
      for (var i in incidents) {
        await incidentBox.put(i.id, i);
      }
      
      await settingsBox.put('hasSeededData', true);
    }
  }

  // Helper Methods
  static Box<IncidentModel> getIncidentBox() {
    return Hive.box<IncidentModel>(AppConstants.incidentBox);
  }
  
  static Box<ResponderModel> getResponderBox() {
    return Hive.box<ResponderModel>(AppConstants.responderBox);
  }
}
