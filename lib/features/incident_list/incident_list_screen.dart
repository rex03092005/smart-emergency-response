import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/incident_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/offline_banner.dart';
import 'widgets/incident_card.dart';

class IncidentListScreen extends ConsumerWidget {
  const IncidentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                label: Text(incidents.length.toString()),
                child: const Icon(LucideIcons.clipboardList),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: incidents.isEmpty
                ? const EmptyState(
                    message: 'No incidents reported yet',
                    icon: LucideIcons.clipboardSignature,
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Logic to refresh or sync
                    },
                    child: ListView.builder(
                      itemCount: incidents.length,
                      itemBuilder: (context, index) {
                        return IncidentCard(incident: incidents[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
