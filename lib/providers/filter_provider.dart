import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/incident_model.dart';
import 'incident_provider.dart';

class FilterState {
  final String query;
  final Set<IncidentStatus> statuses;
  final Set<IncidentPriority> priorities;
  final Set<IncidentCategory> categories;

  FilterState({
    this.query = '',
    this.statuses = const {},
    this.priorities = const {},
    this.categories = const {},
  });

  FilterState copyWith({
    String? query,
    Set<IncidentStatus>? statuses,
    Set<IncidentPriority>? priorities,
    Set<IncidentCategory>? categories,
  }) {
    return FilterState(
      query: query ?? this.query,
      statuses: statuses ?? this.statuses,
      priorities: priorities ?? this.priorities,
      categories: categories ?? this.categories,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void toggleStatus(IncidentStatus status) {
    final statuses = Set<IncidentStatus>.from(state.statuses);
    if (statuses.contains(status)) {
      statuses.remove(status);
    } else {
      statuses.add(status);
    }
    state = state.copyWith(statuses: statuses);
  }

  void togglePriority(IncidentPriority priority) {
    final priorities = Set<IncidentPriority>.from(state.priorities);
    if (priorities.contains(priority)) {
      priorities.remove(priority);
    } else {
      priorities.add(priority);
    }
    state = state.copyWith(priorities: priorities);
  }

  void toggleCategory(IncidentCategory category) {
    final categories = Set<IncidentCategory>.from(state.categories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(categories: categories);
  }

  void clearFilters() {
    state = FilterState();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

final filteredIncidentsProvider = Provider<List<IncidentModel>>((ref) {
  final incidents = ref.watch(incidentProvider);
  final filter = ref.watch(filterProvider);

  return incidents.where((incident) {
    if (filter.query.isNotEmpty) {
      final q = filter.query.toLowerCase();
      final matchQuery = incident.title.toLowerCase().contains(q) || 
                         incident.description.toLowerCase().contains(q) ||
                         incident.id.toLowerCase().contains(q) ||
                         incident.location.toLowerCase().contains(q);
      if (!matchQuery) return false;
    }

    if (filter.statuses.isNotEmpty && !filter.statuses.contains(incident.status)) {
      return false;
    }

    if (filter.priorities.isNotEmpty && !filter.priorities.contains(incident.priority)) {
      return false;
    }

    if (filter.categories.isNotEmpty && !filter.categories.contains(incident.category)) {
      return false;
    }

    return true;
  }).toList();
});
