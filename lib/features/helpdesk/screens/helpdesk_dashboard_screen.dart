import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';
import 'package:e_ticketing_app/features/tickets/providers/ticket_providers.dart';

class HelpdeskDashboardScreen extends ConsumerWidget {
  const HelpdeskDashboardScreen({super.key});

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
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpdesk Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: currentUser.when(
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Helpdesk, ${user?.name ?? ''}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  children: [
                    _MenuItem(
                      icon: Icons.assignment_outlined,
                      title: 'Assigned Tickets',
                      description: 'Track your handled tickets',
                      color: AppColors.primary,
                      onTap: () => context.push('/tickets'),
                    ),
                    _MenuItem(
                      icon: Icons.update_outlined,
                      title: 'Update Status',
                      description: 'Respond and close tickets',
                      color: AppColors.statusInProgress,
                      onTap: () => context.push('/tickets'),
                    ),
                    _MenuItem(
                      icon: Icons.history_toggle_off,
                      title: 'Handling History',
                      description: 'See ticket activity timeline',
                      color: AppColors.secondary,
                      onTap: () => context.push('/tickets'),
                    ),
                    _MenuItem(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      description: 'Account settings',
                      color: AppColors.statusDone,
                      onTap: () => context.push('/profile'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                ref.watch(dashboardStatsProvider).when(
                      data: (stats) => Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _StatChip('Open', '${stats.open}', AppColors.statusOpen),
                          _StatChip('Progress', '${stats.inProgress}', AppColors.statusInProgress),
                          _StatChip('Done', '${stats.done}', AppColors.statusDone),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withAlpha(100)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatChip(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Text('$label: $count'),
    );
  }
}
