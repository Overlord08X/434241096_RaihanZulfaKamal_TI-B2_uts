import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/core/utils/utils.dart';
import 'package:e_ticketing_app/features/tickets/providers/ticket_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: () async {
                  await ref
                      .read(ticketServiceProvider)
                      .markNotificationAsRead(item.id);
                  ref.invalidate(notificationsProvider);
                  if (context.mounted) {
                    context.push('/ticket/${item.ticketId}');
                  }
                },
                tileColor: item.isRead
                    ? Colors.transparent
                    : AppColors.primaryContainer.withAlpha(90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                leading: Icon(
                  item.isRead
                      ? Icons.notifications_none
                      : Icons.notifications_active_outlined,
                ),
                title: Text(item.title),
                subtitle: Text(
                  '${item.body}\n${formatDateTime(item.createdAt)}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemCount: items.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
