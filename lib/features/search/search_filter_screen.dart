import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/filter_provider.dart';
import '../../models/incident_model.dart';
import '../../core/utils/priority_helper.dart';
import '../incident_list/widgets/incident_card.dart';
import '../../shared/widgets/empty_state.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(filterProvider.notifier).setQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredIncidents = ref.watch(filteredIncidentsProvider);
    final filterState = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              ref.read(filterProvider.notifier).clearFilters();
              _searchController.clear();
            },
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ID, title, location...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
                  color: _showFilters ? Theme.of(context).colorScheme.primary : null,
                  onPressed: () {
                    setState(() => _showFilters = !_showFilters);
                  },
                ),
              ],
            ),
          ),
          if (_showFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: IncidentPriority.values.map((p) {
                      final isSelected = filterState.priorities.contains(p);
                      return FilterChip(
                        label: Text(PriorityHelper.getPriorityString(p), style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (_) => ref.read(filterProvider.notifier).togglePriority(p),
                        selectedColor: PriorityHelper.getPriorityColor(p).withOpacity(0.3),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: IncidentStatus.values.map((s) {
                      final isSelected = filterState.statuses.contains(s);
                      return FilterChip(
                        label: Text(PriorityHelper.getStatusString(s), style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (_) => ref.read(filterProvider.notifier).toggleStatus(s),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${filteredIncidents.length} results',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: filteredIncidents.isEmpty
                ? const EmptyState(message: 'No incidents match your search')
                : ListView.builder(
                    itemCount: filteredIncidents.length,
                    itemBuilder: (context, index) {
                      return IncidentCard(incident: filteredIncidents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
