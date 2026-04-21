enum TicketPriority { low, medium, high }

enum TicketStatus { open, inProgress, done }

class Ticket {
  final String id;
  final String title;
  final String description;
  final TicketPriority priority;
  final TicketStatus status;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TicketPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => TicketPriority.medium,
      ),
      status: TicketStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TicketStatus.open,
      ),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    TicketPriority? priority,
    TicketStatus? status,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
