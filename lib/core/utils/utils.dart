import 'package:e_ticketing_app/shared/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';

class TicketStatusUtils {
  static String getStatusLabel(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.done:
        return 'Done';
    }
  }

  static Color getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return AppColors.statusOpen;
      case TicketStatus.inProgress:
        return AppColors.statusInProgress;
      case TicketStatus.done:
        return AppColors.statusDone;
    }
  }

  static IconData getStatusIcon(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Icons.schedule;
      case TicketStatus.inProgress:
        return Icons.hourglass_top;
      case TicketStatus.done:
        return Icons.check_circle;
    }
  }
}

class TicketPriorityUtils {
  static String getPriorityLabel(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
    }
  }

  static Color getPriorityColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return AppColors.priorityLow;
      case TicketPriority.medium:
        return AppColors.priorityMedium;
      case TicketPriority.high:
        return AppColors.priorityHigh;
    }
  }

  static IconData getPriorityIcon(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return Icons.arrow_downward;
      case TicketPriority.medium:
        return Icons.arrow_forward;
      case TicketPriority.high:
        return Icons.arrow_upward;
    }
  }
}

class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }
}

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'now';
  }
}
