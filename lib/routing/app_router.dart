import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/features/auth/screens/login_screen.dart';
import 'package:e_ticketing_app/features/auth/screens/register_screen.dart';
import 'package:e_ticketing_app/features/auth/screens/reset_password_screen.dart';
import 'package:e_ticketing_app/features/dashboard/screens/role_dashboard_screen.dart';
import 'package:e_ticketing_app/features/notifications/screens/notifications_screen.dart';
import 'package:e_ticketing_app/features/profile/screens/profile_screen.dart';
import 'package:e_ticketing_app/features/splash/screens/splash_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/create_ticket_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/ticket_list_screen.dart';
import 'package:e_ticketing_app/features/tickets/screens/ticket_detail_screen.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashScreen(),
          );
        },
      ),
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
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: RegisterScreen(),
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset_password',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ResetPasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: RoleDashboardScreen(),
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
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: NotificationsScreen(),
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

      const publicPaths = <String>{
        '/splash',
        '/login',
        '/register',
        '/reset-password',
      };

      if (publicPaths.any(location.startsWith)) {
        return null;
      }

      try {
        final authService = await ref.read(authServiceProvider.future);
        final isLoggedIn = authService.isLoggedIn();

        if (!isLoggedIn) {
          return '/login';
        }
      } catch (e) {
        return '/login';
      }

      return null;
    },
  );
});
