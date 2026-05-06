import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/utils/priority_helper.dart';
import '../../models/incident_model.dart';
import '../../providers/incident_provider.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class ReportScreen extends ConsumerStatefulWidget {
  final String? initialPriority;

  const ReportScreen({Key? key, this.initialPriority}) : super(key: key);

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  IncidentCategory _selectedCategory = IncidentCategory.other;
  IncidentPriority _selectedPriority = IncidentPriority.low;
  
  bool _isLoading = false;
  double? _lat;
  double? _lng;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    if (widget.initialPriority == 'critical') {
      _selectedPriority = IncidentPriority.critical;
    }
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
          _locationController.text = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)} (GPS)";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get location')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final incident = IncidentModel.create(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        priority: _selectedPriority,
        location: _locationController.text,
        latitude: _lat,
        longitude: _lng,
      );
      
      await ref.read(incidentProvider.notifier).addIncident(incident);
      
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report submitted: ${incident.id}'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } else {
      // Shake animation
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
      ),
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final sineValue = 
              _shakeController.value == 0 ? 0 : 
              _shakeController.value * 2 * 3.14159 * 3; // 3 shakes
          final offset = _shakeController.isAnimating ? 10 * (sineValue.isNaN ? 0 : (sineValue % 1)) : 0.0;
          return Transform.translate(
            offset: Offset(offset.toDouble(), 0),
            child: child,
          );
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Incident Title',
                isRequired: true,
                hint: 'Brief description of the emergency',
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                isRequired: true,
                maxLines: 4,
                hint: 'Provide details...',
                validator: (val) => val == null || val.length < 10 ? 'At least 10 characters required' : null,
              ),
              const SizedBox(height: 24),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: IncidentCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(PriorityHelper.getCategoryString(cat)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = cat);
                        },
                        avatar: Icon(PriorityHelper.getCategoryIcon(cat), size: 18, color: isSelected ? Colors.white : Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SegmentedButton<IncidentPriority>(
                segments: IncidentPriority.values.map((p) {
                  return ButtonSegment<IncidentPriority>(
                    value: p,
                    label: Text(
                      PriorityHelper.getPriorityString(p),
                      style: TextStyle(fontSize: 12, color: _selectedPriority == p ? Colors.white : null),
                    ),
                  );
                }).toList(),
                selected: {_selectedPriority},
                onSelectionChanged: (set) {
                  setState(() => _selectedPriority = set.first);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return PriorityHelper.getPriorityColor(_selectedPriority);
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                isRequired: true,
                hint: 'Enter address or use GPS',
                validator: (val) => val == null || val.isEmpty ? 'Location required' : null,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _getLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Use My Location'),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'SUBMIT REPORT',
                onPressed: _submit,
                isLoading: _isLoading,
                color: PriorityHelper.getPriorityColor(_selectedPriority),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
