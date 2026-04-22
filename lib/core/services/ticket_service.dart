import 'package:e_ticketing_app/shared/models/ticket_model.dart';

class TicketService {
  TicketService._();
  static final TicketService _instance = TicketService._();
  factory TicketService() => _instance;

  final List<AppNotificationItem> _notifications = [];

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
      assigneeName: 'Helpdesk A',
      attachments: [
        TicketAttachment(
          id: 'att_1',
          name: 'login_error.png',
          path: '/dummy/login_error.png',
          source: AttachmentSource.gallery,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      comments: [
        TicketComment(
          id: 'com_1',
          ticketId: '1',
          authorId: '1',
          authorName: 'demo',
          message: 'Saya tidak bisa masuk sejak pagi.',
          isStaff: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TicketComment(
          id: 'com_2',
          ticketId: '1',
          authorId: 'helpdesk_a',
          authorName: 'Helpdesk A',
          message: 'Kami cek, mohon coba clear cache aplikasi.',
          isStaff: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      histories: [
        TicketHistory(
          id: 'his_1',
          ticketId: '1',
          action: 'Ticket created',
          actorName: 'demo',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TicketHistory(
          id: 'his_2',
          ticketId: '1',
          action: 'Assigned to Helpdesk A',
          actorName: 'Admin',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
        ),
        TicketHistory(
          id: 'his_3',
          ticketId: '1',
          action: 'Status changed to In Progress',
          actorName: 'Helpdesk A',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 19)),
        ),
      ],
    ),
    Ticket(
      id: '2',
      title: 'App crashes on startup',
      description: 'App closes immediately after opening',
      priority: TicketPriority.high,
      status: TicketStatus.open,
      userId: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      histories: [
        TicketHistory(
          id: 'his_4',
          ticketId: '2',
          action: 'Ticket created',
          actorName: 'demo',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
  ];

  int _ticketCounter = 3;

  Future<List<Ticket>> getAllTickets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Ticket>.from(_mockTickets);
  }

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
    required String creatorName,
    List<TicketAttachment> attachments = const [],
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final id = _ticketCounter.toString();
    final ticket = Ticket(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: TicketStatus.open,
      userId: userId,
      createdAt: DateTime.now(),
      attachments: attachments,
      histories: [
        TicketHistory(
          id: 'his_${DateTime.now().microsecondsSinceEpoch}',
          ticketId: id,
          action: 'Ticket created',
          actorName: creatorName,
          createdAt: DateTime.now(),
        ),
      ],
    );

    _mockTickets.add(ticket);
    _ticketCounter++;
    _pushNotification(
      ticketId: id,
      title: 'New Ticket',
      body: 'Ticket "$title" berhasil dibuat.',
    );

    return ticket;
  }

  Future<Ticket> updateTicketStatus(
    String ticketId,
    TicketStatus status,
    String actorName,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw Exception('Ticket not found');

    final updatedTicket = _mockTickets[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
      histories: [
        ..._mockTickets[index].histories,
        TicketHistory(
          id: 'his_${DateTime.now().microsecondsSinceEpoch}',
          ticketId: ticketId,
          action: 'Status changed to ${_statusLabel(status)}',
          actorName: actorName,
          createdAt: DateTime.now(),
        ),
      ],
    );

    _mockTickets[index] = updatedTicket;
    _pushNotification(
      ticketId: ticketId,
      title: 'Ticket Updated',
      body: 'Status ticket #$ticketId menjadi ${_statusLabel(status)}.',
    );
    return updatedTicket;
  }

  Future<Ticket> assignTicket(
    String ticketId, {
    required String assigneeName,
    required String actorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw Exception('Ticket not found');

    final updatedTicket = _mockTickets[index].copyWith(
      assigneeName: assigneeName,
      updatedAt: DateTime.now(),
      histories: [
        ..._mockTickets[index].histories,
        TicketHistory(
          id: 'his_${DateTime.now().microsecondsSinceEpoch}',
          ticketId: ticketId,
          action: 'Assigned to $assigneeName',
          actorName: actorName,
          createdAt: DateTime.now(),
        ),
      ],
    );

    _mockTickets[index] = updatedTicket;
    _pushNotification(
      ticketId: ticketId,
      title: 'Ticket Assigned',
      body: 'Ticket #$ticketId di-assign ke $assigneeName.',
    );
    return updatedTicket;
  }

  Future<Ticket> addComment({
    required String ticketId,
    required String authorId,
    required String authorName,
    required String message,
    required bool isStaff,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index == -1) throw Exception('Ticket not found');

    final comment = TicketComment(
      id: 'com_${DateTime.now().microsecondsSinceEpoch}',
      ticketId: ticketId,
      authorId: authorId,
      authorName: authorName,
      message: message,
      isStaff: isStaff,
      createdAt: DateTime.now(),
    );

    final updatedTicket = _mockTickets[index].copyWith(
      updatedAt: DateTime.now(),
      comments: [..._mockTickets[index].comments, comment],
      histories: [
        ..._mockTickets[index].histories,
        TicketHistory(
          id: 'his_${DateTime.now().microsecondsSinceEpoch}',
          ticketId: ticketId,
          action: 'New comment from $authorName',
          actorName: authorName,
          createdAt: DateTime.now(),
        ),
      ],
    );

    _mockTickets[index] = updatedTicket;
    _pushNotification(
      ticketId: ticketId,
      title: 'New Reply',
      body: '$authorName menambahkan komentar di ticket #$ticketId.',
    );
    return updatedTicket;
  }

  Future<List<AppNotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<AppNotificationItem>.from(_notifications);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
  }

  Future<void> deleteTicket(String ticketId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTickets.removeWhere((t) => t.id == ticketId);
  }

  void _pushNotification({
    required String ticketId,
    required String title,
    required String body,
  }) {
    _notifications.insert(
      0,
      AppNotificationItem(
        id: 'notif_${DateTime.now().microsecondsSinceEpoch}',
        ticketId: ticketId,
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
  }

  String _statusLabel(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.done:
        return 'Done';
    }
  }
}
