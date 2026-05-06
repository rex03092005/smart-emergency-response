import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityServiceProvider = Provider((ref) => ConnectivityService());

final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream.map((result) {
    return result != ConnectivityResult.none;
  });
});
