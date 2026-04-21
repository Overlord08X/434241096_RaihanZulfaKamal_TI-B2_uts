import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/core/services/ticket_service.dart';
import 'package:e_ticketing_app/shared/models/ticket_model.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';

final ticketServiceProvider = Provider<TicketService>((ref) {
  return TicketService();
});

final userTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  final ticketService = ref.watch(ticketServiceProvider);

  if (user == null) return [];
  return await ticketService.getTickets(user.id);
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
  );
});
