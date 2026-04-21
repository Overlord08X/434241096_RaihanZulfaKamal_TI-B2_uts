import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_ticketing_app/core/constants/app_constants.dart';
import 'package:e_ticketing_app/core/utils/utils.dart';
import 'package:e_ticketing_app/core/services/ticket_service.dart';
import 'package:e_ticketing_app/shared/models/ticket_model.dart';
import 'package:e_ticketing_app/shared/widgets/custom_widgets.dart';
import 'package:e_ticketing_app/features/auth/providers/auth_providers.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  TicketPriority _selectedPriority = TicketPriority.medium;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final ticketService = TicketService();
      final user = await ref.read(currentUserProvider.future);

      if (user == null) {
        throw Exception('User not authenticated');
      }

      await ticketService.createTicket(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        userId: user.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket created successfully!'),
            backgroundColor: AppColors.statusDone,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating ticket: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Ticket'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              CustomTextField(
                label: 'Ticket Title',
                hint: 'Brief title of the issue',
                controller: _titleController,
                validator: ValidationUtils.validateTitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Description Field
              CustomTextField(
                label: 'Description',
                hint: 'Describe the issue in detail',
                controller: _descriptionController,
                maxLines: 5,
                validator: ValidationUtils.validateDescription,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Priority Dropdown
              Text(
                'Priority',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.outline.withAlpha(50),
                  ),
                ),
                child: DropdownButton<TicketPriority>(
                  value: _selectedPriority,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: TicketPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Icon(
                            TicketPriorityUtils.getPriorityIcon(priority),
                            color:
                                TicketPriorityUtils.getPriorityColor(priority),
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            TicketPriorityUtils.getPriorityLabel(priority),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (priority) {
                    if (priority != null) {
                      setState(() => _selectedPriority = priority);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Priority Info
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: TicketPriorityUtils.getPriorityColor(_selectedPriority)
                      .withAlpha(20),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: TicketPriorityUtils.getPriorityColor(_selectedPriority)
                        .withAlpha(100),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      TicketPriorityUtils.getPriorityIcon(_selectedPriority),
                      color: TicketPriorityUtils.getPriorityColor(
                          _selectedPriority),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Priority',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.outline,
                                    ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            TicketPriorityUtils.getPriorityLabel(
                                _selectedPriority),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Submit Button
              CustomButton(
                text: 'Create Ticket',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              // Cancel Button
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.outline,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
