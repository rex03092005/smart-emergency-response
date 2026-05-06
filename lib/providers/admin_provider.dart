import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responder_model.dart';
import '../services/hive_service.dart';

class ResponderNotifier extends StateNotifier<List<ResponderModel>> {
  ResponderNotifier() : super([]) {
    _loadResponders();
  }

  void _loadResponders() {
    final box = HiveService.getResponderBox();
    state = box.values.toList();
  }

  Future<void> addResponder(ResponderModel responder) async {
    final box = HiveService.getResponderBox();
    await box.put(responder.id, responder);
    _loadResponders();
  }

  Future<void> updateResponder(ResponderModel responder) async {
    final box = HiveService.getResponderBox();
    await box.put(responder.id, responder);
    _loadResponders();
  }
}

final responderProvider = StateNotifierProvider<ResponderNotifier, List<ResponderModel>>((ref) {
  return ResponderNotifier();
});

final responderByIdProvider = Provider.family<ResponderModel?, String>((ref, id) {
  final responders = ref.watch(responderProvider);
  try {
    return responders.firstWhere((element) => element.id == id);
  } catch (e) {
    return null;
  }
});
