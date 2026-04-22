import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/core/providers/theme_provider.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';
import 'package:e_ticketing_app/shared/widgets/custom_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final authService = await ref.read(authServiceProvider.future);
    await authService.logout();
    refreshAuthState(ref);
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          final isDark = themeMode == ThemeMode.dark;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  user.name.isNotEmpty
                      ? user.name[0].toUpperCase()
                      : 'U',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Center(
                child: Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.outline,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Card(
                child: SwitchListTile(
                  value: isDark,
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Switch between light and dark theme'),
                  onChanged: (value) {
                    ref
                        .read(themeModeProvider.notifier)
                        .toggleDarkMode(value);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Role'),
                  subtitle: Text(user.role.name.toUpperCase()),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Logout',
                onPressed: () => _logout(context, ref),
                backgroundColor: AppColors.error,
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(message: 'Loading profile...'),
        error: (error, stack) => AppErrorWidget(message: error.toString()),
      ),
    );
  }
}
