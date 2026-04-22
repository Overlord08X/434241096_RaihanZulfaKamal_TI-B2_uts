import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/features/admin/screens/admin_dashboard_screen.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';
import 'package:e_ticketing_app/features/helpdesk/screens/helpdesk_dashboard_screen.dart';
import 'package:e_ticketing_app/features/user/screens/user_dashboard_screen.dart';
import 'package:e_ticketing_app/shared/models/user_model.dart';

class RoleDashboardScreen extends ConsumerWidget {
  const RoleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User session not found')),
          );
        }

        switch (user.role) {
          case UserRole.admin:
            return const AdminDashboardScreen();
          case UserRole.helpdesk:
            return const HelpdeskDashboardScreen();
          case UserRole.user:
            return const UserDashboardScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
