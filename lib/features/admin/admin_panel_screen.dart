import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/incident_provider.dart';
import '../../models/incident_model.dart';
import '../incident_list/widgets/incident_card.dart';

class AdminPanelScreen extends ConsumerWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark All Resolved',
            onPressed: () => _showBulkResolveDialog(context, ref),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Critical'),
                Tab(text: 'In Progress'),
                Tab(text: 'Unassigned'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(incidents),
                  _buildList(incidents.where((i) => i.priority == IncidentPriority.critical).toList()),
                  _buildList(incidents.where((i) => i.status == IncidentStatus.inProgress).toList()),
                  _buildList(incidents.where((i) => i.assignedResponder == null).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<IncidentModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No incidents found.'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return IncidentCard(incident: list[index]);
      },
    );
  }

  void _showBulkResolveDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve All?'),
        content: const Text('Are you sure you want to mark all active incidents as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(incidentProvider.notifier).markAllResolved();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All incidents marked as resolved.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('RESOLVE ALL'),
          ),
        ],
      ),
    );
  }
}
