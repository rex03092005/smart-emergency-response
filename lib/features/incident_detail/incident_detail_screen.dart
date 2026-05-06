import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/incident_provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/incident_model.dart';
import '../../core/utils/priority_helper.dart';
import '../../core/utils/date_formatter.dart';
import '../../shared/widgets/empty_state.dart';

class IncidentDetailScreen extends ConsumerWidget {
  final String incidentId;

  const IncidentDetailScreen({Key? key, required this.incidentId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incident = ref.watch(incidentByIdProvider(incidentId));

    if (incident == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Incident Not Found')),
        body: const EmptyState(message: 'This incident could not be found.'),
      );
    }

    final priorityColor = PriorityHelper.getPriorityColor(incident.priority);

    return Scaffold(
      appBar: AppBar(
        title: Text(incident.id),
        backgroundColor: priorityColor,
        actions: [
          if (!incident.isSynced)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.cloud_off),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: priorityColor.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(PriorityHelper.getCategoryIcon(incident.category), color: priorityColor),
                      const SizedBox(width: 8),
                      Text(
                        incident.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    incident.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _InfoRow(icon: LucideIcons.mapPin, label: 'Location', value: incident.location),
            const SizedBox(height: 12),
            _InfoRow(icon: LucideIcons.calendarClock, label: 'Reported At', value: DateFormatter.formatDateTime(incident.reportedAt)),
            const SizedBox(height: 12),
            _InfoRow(icon: LucideIcons.user, label: 'Reported By', value: incident.reportedBy),
            const SizedBox(height: 12),
            _InfoRow(
              icon: LucideIcons.activity,
              label: 'Status',
              value: PriorityHelper.getStatusString(incident.status),
              valueColor: PriorityHelper.getStatusColor(incident.status),
            ),
            const SizedBox(height: 24),
            const Text('Status Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _StatusTimeline(currentStatus: incident.status),
            const SizedBox(height: 24),
            if (incident.assignedResponder != null) ...[
              const Text('Assigned Responder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, _) {
                final responder = ref.watch(responderByIdProvider(incident.assignedResponder!));
                if (responder == null) return const Text('Responder details not available');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(LucideIcons.userCheck, color: Colors.white),
                  ),
                  title: Text(responder.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(responder.role),
                  tileColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }),
              const SizedBox(height: 24),
            ],
            if (incident.notes.isNotEmpty) ...[
              const Text('Admin Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: incident.notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(incident.notes[index]),
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ),
      ],
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final IncidentStatus currentStatus;

  const _StatusTimeline({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final statuses = IncidentStatus.values;
    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index <= currentIndex;
        final isLast = index == statuses.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? PriorityHelper.getStatusColor(status) : Colors.grey.shade300,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isCompleted ? PriorityHelper.getStatusColor(status) : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    PriorityHelper.getStatusString(status),
                    style: TextStyle(
                      fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
