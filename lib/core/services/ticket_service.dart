import 'package:e_ticketing_app/shared/models/ticket_model.dart';

class TicketService {
  // Mock data for demonstration
  final List<Ticket> _mockTickets = [
    Ticket(
      id: '1',
      title: 'Login not working',
      description: 'Cannot login to the system',
      priority: TicketPriority.high,
      status: TicketStatus.inProgress,
      userId: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Ticket(
      id: '2',
      title: 'App crashes on startup',
      description: 'App closes immediately after opening',
      priority: TicketPriority.high,
      status: TicketStatus.open,
      userId: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  int _ticketCounter = 3;

  Future<List<Ticket>> getTickets(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTickets.where((t) => t.userId == userId).toList();
  }

  Future<Ticket?> getTicketById(String ticketId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockTickets.firstWhere((t) => t.id == ticketId);
    } catch (e) {
      return null;
    }
  }

  Future<Ticket> createTicket({
    required String title,
    required String description,
    required TicketPriority priority,
    required String userId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final ticket = Ticket(
      id: _ticketCounter.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TicketStatus.open,
      userId: userId,
      createdAt: DateTime.now(),
    );

    _mockTickets.add(ticket);
    _ticketCounter++;

    return ticket;
  }

  Future<Ticket> updateTicketStatus(
    String ticketId,
    TicketStatus status,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw Exception('Ticket not found');

    final updatedTicket = _mockTickets[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    _mockTickets[index] = updatedTicket;
    return updatedTicket;
  }

  Future<void> deleteTicket(String ticketId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTickets.removeWhere((t) => t.id == ticketId);
  }
}
