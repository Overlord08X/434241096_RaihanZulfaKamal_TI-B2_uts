import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_ticketing_app/core/services/auth_service.dart';
import 'package:e_ticketing_app/core/services/api_service.dart';
import 'package:e_ticketing_app/shared/models/user_model.dart';

// Service Providers
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthService(prefs);
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Auth State Providers
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = await ref.watch(authServiceProvider.future);
  return authService.getCurrentUser();
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = await ref.watch(authServiceProvider.future);
  return authService.isLoggedIn();
});

void refreshAuthState(WidgetRef ref) {
  ref.invalidate(currentUserProvider);
  ref.invalidate(isLoggedInProvider);
}
