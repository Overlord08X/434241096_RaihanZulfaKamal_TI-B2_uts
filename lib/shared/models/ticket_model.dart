enum TicketPriority { low, medium, high }

enum TicketStatus { open, inProgress, done }

enum AttachmentSource { camera, gallery, file }

class TicketAttachment {
  final String id;
  final String name;
  final String path;
  final AttachmentSource source;
  final DateTime createdAt;

  TicketAttachment({
    required this.id,
    required this.name,
    required this.path,
    required this.source,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'source': source.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TicketAttachment.fromJson(Map<String, dynamic> json) {
    return TicketAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      source: AttachmentSource.values.firstWhere(
        (e) => e.name == (json['source'] as String? ?? 'file'),
        orElse: () => AttachmentSource.file,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class TicketComment {
  final String id;
  final String ticketId;
  final String authorId;
  final String authorName;
  final String message;
  final bool isStaff;
  final DateTime createdAt;

  TicketComment({
    required this.id,
    required this.ticketId,
    required this.authorId,
    required this.authorName,
    required this.message,
    required this.isStaff,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'authorId': authorId,
      'authorName': authorName,
      'message': message,
      'isStaff': isStaff,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TicketComment.fromJson(Map<String, dynamic> json) {
    return TicketComment(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      message: json['message'] as String,
      isStaff: json['isStaff'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class TicketHistory {
  final String id;
  final String ticketId;
  final String action;
  final String actorName;
  final DateTime createdAt;

  TicketHistory({
    required this.id,
    required this.ticketId,
    required this.action,
    required this.actorName,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'action': action,
      'actorName': actorName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TicketHistory.fromJson(Map<String, dynamic> json) {
    return TicketHistory(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      action: json['action'] as String,
      actorName: json['actorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AppNotificationItem {
  final String id;
  final String ticketId;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationItem({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotificationItem copyWith({
    bool? isRead,
  }) {
    return AppNotificationItem(
      id: id,
      ticketId: ticketId,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class Ticket {
  final String id;
  final String title;
  final String description;
  final TicketPriority priority;
  final TicketStatus status;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? assigneeName;
  final List<TicketAttachment> attachments;
  final List<TicketComment> comments;
  final List<TicketHistory> histories;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
    this.assigneeName,
    this.attachments = const [],
    this.comments = const [],
    this.histories = const [],
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
        assigneeName: json['assigneeName'] as String?,
        attachments: ((json['attachments'] as List<dynamic>?) ?? [])
          .map((e) => TicketAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
        comments: ((json['comments'] as List<dynamic>?) ?? [])
          .map((e) => TicketComment.fromJson(e as Map<String, dynamic>))
          .toList(),
        histories: ((json['histories'] as List<dynamic>?) ?? [])
          .map((e) => TicketHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'assigneeName': assigneeName,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'histories': histories.map((e) => e.toJson()).toList(),
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
    String? assigneeName,
    List<TicketAttachment>? attachments,
    List<TicketComment>? comments,
    List<TicketHistory>? histories,
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
      assigneeName: assigneeName ?? this.assigneeName,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      histories: histories ?? this.histories,
    );
  }
}
