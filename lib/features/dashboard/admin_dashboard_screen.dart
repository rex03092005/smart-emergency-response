import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../../providers/incident_provider.dart';
import '../../models/incident_model.dart';
import '../../core/utils/priority_helper.dart';
import '../incident_list/widgets/incident_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentProvider);
    
    final total = incidents.length;
    final active = incidents.where((i) => i.status == IncidentStatus.reported || i.status == IncidentStatus.inProgress).length;
    final resolvedToday = incidents.where((i) => 
      i.status == IncidentStatus.resolved && 
      i.updatedAt.day == DateTime.now().day
    ).length;
    final critical = incidents.where((i) => i.priority == IncidentPriority.critical).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Future settings
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(child: _StatCard(title: 'Total Incidents', value: total.toString(), color: Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _StatCard(title: 'Active Cases', value: active.toString(), color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _StatCard(title: 'Resolved Today', value: resolvedToday.toString(), color: Colors.green)),
                const SizedBox(width: 8),
                Expanded(child: _StatCard(title: 'Critical', value: critical.toString(), color: Colors.red)),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text('Priority Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    _buildPieChartSection(incidents, IncidentPriority.critical),
                    _buildPieChartSection(incidents, IncidentPriority.high),
                    _buildPieChartSection(incidents, IncidentPriority.medium),
                    _buildPieChartSection(incidents, IncidentPriority.low),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Incidents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: () => context.push('/admin'),
                  child: const Text('Manage All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...incidents.take(5).map((i) => IncidentCard(incident: i)).toList(),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _buildPieChartSection(List<IncidentModel> incidents, IncidentPriority priority) {
    final count = incidents.where((i) => i.priority == priority).length;
    final total = incidents.length;
    final percentage = total == 0 ? 0 : (count / total) * 100;
    
    return PieChartSectionData(
      color: PriorityHelper.getPriorityColor(priority),
      value: count.toDouble(),
      title: '${percentage.toStringAsFixed(0)}%',
      radius: 50,
      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
