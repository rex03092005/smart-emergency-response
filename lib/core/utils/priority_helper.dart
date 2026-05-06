import 'package:flutter/material.dart';
import '../../models/incident_model.dart';
import '../theme/app_colors.dart';

class PriorityHelper {
  static Color getPriorityColor(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return AppColors.priorityCritical;
      case IncidentPriority.high:
        return AppColors.priorityHigh;
      case IncidentPriority.medium:
        return AppColors.priorityMedium;
      case IncidentPriority.low:
        return AppColors.priorityLow;
    }
  }

  static String getPriorityString(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return "CRITICAL";
      case IncidentPriority.high:
        return "HIGH";
      case IncidentPriority.medium:
        return "MEDIUM";
      case IncidentPriority.low:
        return "LOW";
    }
  }
  
  static int getPriorityWeight(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.critical:
        return 4;
      case IncidentPriority.high:
        return 3;
      case IncidentPriority.medium:
        return 2;
      case IncidentPriority.low:
        return 1;
    }
  }

  static Color getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reported:
        return AppColors.statusReported;
      case IncidentStatus.inProgress:
        return AppColors.statusInProgress;
      case IncidentStatus.resolved:
        return AppColors.statusResolved;
      case IncidentStatus.closed:
        return AppColors.statusClosed;
    }
  }

  static String getStatusString(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reported:
        return "Reported";
      case IncidentStatus.inProgress:
        return "In Progress";
      case IncidentStatus.resolved:
        return "Resolved";
      case IncidentStatus.closed:
        return "Closed";
    }
  }
  
  static String getCategoryString(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.medical:
        return "Medical";
      case IncidentCategory.fire:
        return "Fire";
      case IncidentCategory.security:
        return "Security";
      case IncidentCategory.natural:
        return "Natural";
      case IncidentCategory.infrastructure:
        return "Infrastructure";
      case IncidentCategory.other:
        return "Other";
    }
  }

  static IconData getCategoryIcon(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.medical:
        return Icons.local_hospital;
      case IncidentCategory.fire:
        return Icons.local_fire_department;
      case IncidentCategory.security:
        return Icons.security;
      case IncidentCategory.natural:
        return Icons.water_damage;
      case IncidentCategory.infrastructure:
        return Icons.construction;
      case IncidentCategory.other:
        return Icons.info_outline;
    }
  }
}
