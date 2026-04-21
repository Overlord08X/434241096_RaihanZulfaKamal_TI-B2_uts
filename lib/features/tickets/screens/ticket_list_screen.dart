import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/core/utils/utils.dart';
import 'package:e_ticketing_app/shared/widgets/custom_widgets.dart';
import 'package:e_ticketing_app/features/tickets/providers/ticket_providers.dart';

class TicketListScreen extends ConsumerWidget {
  const TicketListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(userTicketsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/create-ticket'),
          ),
        ],
      ),
      body: ticketsAsync.when(
        data: (tickets) {
          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: AppColors.outline.withAlpha(100),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No tickets yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.outline,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/create-ticket'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Ticket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TicketCard(
                  title: ticket.title,
                  description: ticket.description,
                  status: TicketStatusUtils.getStatusLabel(ticket.status),
                  statusColor: TicketStatusUtils.getStatusColor(ticket.status),
                  statusIcon:
                      TicketStatusUtils.getStatusIcon(ticket.status),
                  onTap: () {
                    context.push('/ticket/${ticket.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Loading tickets...'),
        error: (error, stack) => SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(userTicketsProvider),
            ),
          ),
        ),
      ),
    );
  }
}
