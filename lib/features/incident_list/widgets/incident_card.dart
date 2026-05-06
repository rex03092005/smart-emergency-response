import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/incident_model.dart';
import '../../../core/utils/priority_helper.dart';
import '../../../core/utils/date_formatter.dart';
import 'package:go_router/go_router.dart';

class IncidentCard extends StatefulWidget {
  final IncidentModel incident;

  const IncidentCard({Key? key, required this.incident}) : super(key: key);

  @override
  State<IncidentCard> createState() => _IncidentCardState();
}

class _IncidentCardState extends State<IncidentCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.incident.priority == IncidentPriority.critical) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant IncidentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.incident.priority == IncidentPriority.critical && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (widget.incident.priority != IncidentPriority.critical && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = PriorityHelper.getPriorityColor(widget.incident.priority);

    Widget card = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: widget.incident.priority == IncidentPriority.critical ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.incident.priority == IncidentPriority.critical
            ? BorderSide(color: Colors.red.shade900, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => context.push('/incident/${widget.incident.id}'),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 8,
                color: priorityColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.incident.id,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: priorityColor),
                            ),
                            child: Text(
                              PriorityHelper.getPriorityString(widget.incident.priority),
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.incident.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(PriorityHelper.getCategoryIcon(widget.incident.category), size: 16, color: Colors.grey.shade700),
                          const SizedBox(width: 4),
                          Text(PriorityHelper.getCategoryString(widget.incident.category), style: TextStyle(color: Colors.grey.shade700)),
                          const Spacer(),
                          Text(
                            DateFormatter.formatTimeAgo(widget.incident.reportedAt),
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: PriorityHelper.getStatusColor(widget.incident.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              PriorityHelper.getStatusString(widget.incident.status),
                              style: TextStyle(
                                color: PriorityHelper.getStatusColor(widget.incident.status),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!widget.incident.isSynced) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.cloud_off, size: 16, color: Colors.red),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.incident.priority == IncidentPriority.critical) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: card,
      );
    }

    return card;
  }
}
