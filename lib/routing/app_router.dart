import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/features/auth/screens/login_screen.dart';
import 'package:e_ticketing_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/create_ticket_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/ticket_list_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/ticket_detail_screen.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: DashboardScreen(),
          );
        },
      ),
      GoRoute(
        path: '/tickets',
        name: 'tickets',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: TicketListScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create-ticket',
        name: 'create_ticket',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: CreateTicketScreen(),
          );
        },
      ),
      GoRoute(
        path: '/ticket/:ticketId',
        name: 'ticket_detail',
        pageBuilder: (context, state) {
          final ticketId = state.pathParameters['ticketId'] ?? '';
          return MaterialPage(
            child: TicketDetailScreen(ticketId: ticketId),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text('Error: ${state.error}'),
          ),
        ),
      );
    },
    redirect: (context, state) async {
      final location = state.uri.toString();
      
      // Allow access to login route
      if (location.contains('/login')) {
        return null;
      }

      // Check if user is authenticated
      try {
        final authService = await ref.read(authServiceProvider.future);
        final isLoggedIn = authService.isLoggedIn();

        if (!isLoggedIn && !location.contains('/login')) {
          return '/login';
        }
      } catch (e) {
        return '/login';
      }

      return null;
    },
  );
});
