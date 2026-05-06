import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/app_constants.dart';
import '../../models/incident_model.dart';
import '../../providers/incident_provider.dart';
import '../../shared/widgets/offline_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentProvider);
    final total = incidents.length;
    final active = incidents.where((i) => i.status == IncidentStatus.reported || i.status == IncidentStatus.inProgress).length;
    final resolved = incidents.where((i) => i.status == IncidentStatus.resolved).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Response System'),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _ActionCard(
                        title: 'Report Incident',
                        icon: LucideIcons.siren,
                        color: Colors.red,
                        onTap: () => context.push('/report'),
                      ),
                      _ActionCard(
                        title: 'My Reports',
                        icon: LucideIcons.clipboardList,
                        color: Colors.blue,
                        onTap: () => context.push('/incidents'),
                      ),
                      _ActionCard(
                        title: 'Search',
                        icon: LucideIcons.search,
                        color: Colors.orange,
                        onTap: () => context.push('/search'),
                      ),
                      _ActionCard(
                        title: 'Admin Panel',
                        icon: LucideIcons.shieldCheck,
                        color: Colors.purple,
                        onTap: () => context.push('/dashboard'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(label: 'Total', count: total.toString(), color: Colors.blue),
                      _StatColumn(label: 'Active', count: active.toString(), color: Colors.orange),
                      _StatColumn(label: 'Resolved', count: resolved.toString(), color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/report?priority=critical'),
        backgroundColor: Colors.red.shade700,
        icon: const Icon(LucideIcons.alertTriangle, color: Colors.white),
        label: const Text('Quick SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
