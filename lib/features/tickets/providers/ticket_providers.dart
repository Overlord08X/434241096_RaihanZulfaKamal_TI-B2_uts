import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/core/services/ticket_service.dart';
import 'package:e_ticketing_app/shared/models/ticket_model.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';
import 'package:e_ticketing_app/shared/models/user_model.dart';

final ticketServiceProvider = Provider<TicketService>((ref) {
  return TicketService();
});

class DashboardStats {
  final int total;
  final int open;
  final int inProgress;
  final int done;

  DashboardStats({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.done,
  });
}

final userTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final ticketService = ref.watch(ticketServiceProvider);

  if (user == null) return [];
  return await ticketService.getTickets(user.id);
});

final allTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final ticketService = ref.watch(ticketServiceProvider);
  return await ticketService.getAllTickets();
});

final myOrAllTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  if (user.role == UserRole.admin || user.role == UserRole.helpdesk) {
    return await ref.watch(allTicketsProvider.future);
  }

  return await ref.watch(userTicketsProvider.future);
});

final ticketDetailProvider = FutureProvider.family<Ticket?, String>((ref, ticketId) async {
  final ticketService = ref.watch(ticketServiceProvider);
  return await ticketService.getTicketById(ticketId);
});

final createTicketProvider =
    FutureProvider.family<Ticket, Map<String, dynamic>>((ref, params) async {
  final ticketService = ref.watch(ticketServiceProvider);
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) throw Exception('User not authenticated');

  return await ticketService.createTicket(
    title: params['title'] as String,
    description: params['description'] as String,
    priority: params['priority'] as TicketPriority,
    userId: user.id,
    creatorName: user.name,
    attachments: (params['attachments'] as List<TicketAttachment>?) ?? const [],
  );
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final tickets = await ref.watch(myOrAllTicketsProvider.future);

  return DashboardStats(
    total: tickets.length,
    open: tickets.where((t) => t.status == TicketStatus.open).length,
    inProgress:
        tickets.where((t) => t.status == TicketStatus.inProgress).length,
    done: tickets.where((t) => t.status == TicketStatus.done).length,
  );
});

final notificationsProvider = FutureProvider<List<AppNotificationItem>>((ref) async {
  final ticketService = ref.watch(ticketServiceProvider);
  return await ticketService.getNotifications();
});
