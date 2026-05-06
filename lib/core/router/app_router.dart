import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/report/report_screen.dart';
import '../../features/incident_list/incident_list_screen.dart';
import '../../features/incident_detail/incident_detail_screen.dart';
import '../../features/dashboard/admin_dashboard_screen.dart';
import '../../features/search/search_filter_screen.dart';
import '../../features/admin/admin_panel_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) {
          final priority = state.uri.queryParameters['priority'];
          return ReportScreen(initialPriority: priority);
        },
      ),
      GoRoute(
        path: '/incidents',
        builder: (context, state) => const IncidentListScreen(),
      ),
      GoRoute(
        path: '/incident/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return IncidentDetailScreen(incidentId: id);
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchFilterScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPanelScreen(),
      ),
    ],
  );
});
