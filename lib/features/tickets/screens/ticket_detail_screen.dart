import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/core/utils/utils.dart';
import 'package:e_ticketing_app/shared/models/ticket_model.dart';
import 'package:e_ticketing_app/shared/models/user_model.dart';
import 'package:e_ticketing_app/shared/widgets/custom_widgets.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';
import 'package:e_ticketing_app/features/tickets/providers/ticket_providers.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketDetailScreen({
    super.key,
    required this.ticketId,
  });

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  bool _isUpdating = false;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(TicketStatus newStatus) async {
    setState(() => _isUpdating = true);
    try {
      final ticketService = ref.read(ticketServiceProvider);
      final user = await ref.read(currentUserProvider.future);
      final actorName = user?.name ?? 'System';
      await ticketService.updateTicketStatus(
        widget.ticketId,
        newStatus,
        actorName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket status updated!'),
            backgroundColor: AppColors.statusDone,
          ),
        );
          // Refresh the ticket detail
          ref.invalidate(ticketDetailProvider(widget.ticketId));
          ref.invalidate(myOrAllTicketsProvider);
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(notificationsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _assignTicket() async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;
    if (!mounted) return;

    final assigneeController = TextEditingController();
    final assignee = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Ticket'),
          content: TextField(
            controller: assigneeController,
            decoration: const InputDecoration(
              labelText: 'Assignee Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                assigneeController.text.trim(),
              ),
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );

    if (assignee == null || assignee.isEmpty) return;
    if (!mounted) return;

    setState(() => _isUpdating = true);
    try {
      await ref.read(ticketServiceProvider).assignTicket(
            widget.ticketId,
            assigneeName: assignee,
            actorName: user.name,
          );
      ref.invalidate(ticketDetailProvider(widget.ticketId));
      ref.invalidate(myOrAllTicketsProvider);
      ref.invalidate(notificationsProvider);
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _sendComment(Ticket ticket) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    setState(() => _isUpdating = true);
    try {
      final isStaff = user.role != UserRole.user;
      await ref.read(ticketServiceProvider).addComment(
            ticketId: ticket.id,
            authorId: user.id,
            authorName: user.name,
            message: text,
            isStaff: isStaff,
          );

      _commentController.clear();
      ref.invalidate(ticketDetailProvider(widget.ticketId));
      ref.invalidate(notificationsProvider);
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(ticketDetailProvider(widget.ticketId));
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ticketAsync.when(
        data: (ticket) {
          if (ticket == null) {
            return const AppErrorWidget(message: 'Ticket not found');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket #${ticket.id}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.outline,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            ticket.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(
                      label:
                          TicketStatusUtils.getStatusLabel(ticket.status),
                      backgroundColor:
                          TicketStatusUtils.getStatusColor(ticket.status),
                      icon: TicketStatusUtils.getStatusIcon(ticket.status),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Status and Priority Cards
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: TicketStatusUtils.getStatusIcon(ticket.status),
                        iconColor:
                            TicketStatusUtils.getStatusColor(ticket.status),
                        title: 'Status',
                        value: TicketStatusUtils.getStatusLabel(ticket.status),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _InfoCard(
                        icon: TicketPriorityUtils.getPriorityIcon(
                            ticket.priority),
                        iconColor: TicketPriorityUtils.getPriorityColor(
                            ticket.priority),
                        title: 'Priority',
                        value: TicketPriorityUtils.getPriorityLabel(
                            ticket.priority),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (ticket.assigneeName != null)
                  _InfoCard(
                    icon: Icons.assignment_ind_outlined,
                    iconColor: AppColors.primary,
                    title: 'Assigned To',
                    value: ticket.assigneeName!,
                  ),
                const SizedBox(height: AppSpacing.lg),
                // Created and Updated Dates
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.calendar_today,
                        iconColor: AppColors.primary,
                        title: 'Created',
                        value: formatDateTime(ticket.createdAt),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.update,
                        iconColor: AppColors.secondary,
                        title: 'Updated',
                        value: ticket.updatedAt != null
                            ? formatDateTime(ticket.updatedAt!)
                            : 'Not updated',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Description Section
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.outline.withAlpha(50),
                    ),
                  ),
                  child: Text(
                    ticket.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (ticket.attachments.isNotEmpty) ...[
                  Text(
                    'Attachments',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...ticket.attachments.map(
                    (attachment) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.attach_file),
                        title: Text(attachment.name),
                        subtitle: Text(attachment.source.name),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                userAsync.when(
                  data: (user) {
                    final isStaff = user != null && user.role != UserRole.user;
                    if (!isStaff) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Helpdesk Actions',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: _isUpdating ? null : _assignTicket,
                          icon: const Icon(Icons.assignment_ind_outlined),
                          label: const Text('Assign Ticket'),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Column(
                          children: TicketStatus.values.map((status) {
                            final isCurrentStatus = ticket.status == status;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: ElevatedButton.icon(
                                onPressed: isCurrentStatus || _isUpdating
                                    ? null
                                    : () => _updateStatus(status),
                                icon: Icon(
                                  TicketStatusUtils.getStatusIcon(status),
                                ),
                                label: Text(
                                  TicketStatusUtils.getStatusLabel(status),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      TicketStatusUtils.getStatusColor(status),
                                  minimumSize:
                                      const Size(double.infinity, 48),
                                  disabledBackgroundColor:
                                      TicketStatusUtils.getStatusColor(status)
                                          .withAlpha(100),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Discussion',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...ticket.comments.map(
                  (comment) => Align(
                    alignment: comment.isStaff
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: comment.isStaff
                            ? AppColors.primaryContainer
                            : AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.authorName,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(comment.message),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write comment/reply...',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _isUpdating ? null : () => _sendComment(ticket),
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tracking History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...ticket.histories.reversed.map(
                  (history) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.timeline),
                    title: Text(history.action),
                    subtitle: Text(
                      '${history.actorName} • ${formatDateTime(history.createdAt)}',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingWidget(message: 'Loading ticket...'),
        error: (error, stack) => SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: AppErrorWidget(
              message: error.toString(),
              onRetry: () =>
                  ref.refresh(ticketDetailProvider(widget.ticketId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: iconColor.withAlpha(100),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.outline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
