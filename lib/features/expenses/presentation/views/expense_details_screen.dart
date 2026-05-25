import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/expense_enums.dart';
import '../cubit/expense_details_cubit.dart';
import '../cubit/expense_details_state.dart';
import '../view_model/expense_details_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../widgets/expense_status_badge.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  const ExpenseDetailsScreen({super.key, required this.expenseId});

  final String expenseId;

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseDetailsCubit>().loadExpense(widget.expenseId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseDetailsCubit, ExpenseDetailsState>(
      listener: (context, state) {
        if (state is ExpenseDetailsError) AppToast.error(context, state.message);
        if (state is ExpenseDetailsDeleted) {
          AppToast.success(context, LocaleKeys.expensesDeletedSuccessfully.tr());
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.expenses);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.expensesDetailsTitle.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RoutePaths.expenses);
              }
            },
          ),
        ),
        body: BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
          builder: (context, state) {
            if (state is ExpenseDetailsLoading || state is ExpenseDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpenseDetailsLoaded) {
              return _DetailsBody(
                expense: state.expense,
                lookups: state.lookups,
                onEdit: _openEditExpense,
              );
            }
            return Center(child: Text(LocaleKeys.messagesError.tr()));
          },
        ),
      ),
    );
  }

  Future<void> _openEditExpense(String expenseId) async {
    final wasUpdated = await context.push<bool>('/expenses/$expenseId/edit');
    if (!mounted) return;
    if (wasUpdated == true) {
      await context.read<ExpenseDetailsCubit>().loadExpense(widget.expenseId);
    }
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
    required this.expense,
    required this.lookups,
    required this.onEdit,
  });

  final ExpenseDetailsViewModel expense;
  final ExpenseFormLookupsViewModel lookups;
  final ValueChanged<String> onEdit;

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    ).format(expense.amount);

    return SingleChildScrollView(
      padding: context.responsive(
        mobile: AppSpacing.pagePaddingMobile,
        tablet: AppSpacing.pagePaddingTablet,
        desktop: AppSpacing.pagePaddingDesktop,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Container(
            padding: AppSpacing.paddingAllXl,
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: AppRadius.borderRadiusBase,
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        expense.code,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    ExpenseStatusBadge(status: expense.status),
                  ],
                ),
                AppSpacing.gapH12,
                Text(
                  '$amount ${expense.currency}',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary,
                  ),
                ),
                AppSpacing.gapH24,
                Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.base,
                  children: [
                    _Info(LocaleKeys.expensesDate.tr(), _formatDate(expense.expenseDate)),
                    _Info(LocaleKeys.expensesCategory.tr(), _categoryName(expense.categoryId)),
                    _Info(LocaleKeys.expensesVendor.tr(), _vendorName(expense.vendorId)),
                    _Info(LocaleKeys.expensesPaidFrom.tr(), _accountName(expense.paidFromAccountId)),
                    _Info(LocaleKeys.expensesSubAccount.tr(), _accountName(expense.subAccountId)),
                    _Info(LocaleKeys.expensesTax.tr(), _taxName(expense.taxId)),
                    _Info(LocaleKeys.expensesLinkedJournal.tr(), expense.journalEntryId ?? '-'),
                  ],
                ),
                AppSpacing.gapH24,
                _Info(LocaleKeys.expensesDescription.tr(), expense.description ?? '-'),
                AppSpacing.gapH24,
                _Info(
                  LocaleKeys.expensesRecurring.tr(),
                  expense.isRecurring
                      ? '${_recurrenceTypeLabel()} ${_formatDate(expense.recurrenceEndDate)}'
                      : '-',
                ),
                AppSpacing.gapH24,
                Container(
                  padding: AppSpacing.paddingAllLg,
                  decoration: BoxDecoration(
                    color: context.colors.inputFill,
                    borderRadius: AppRadius.borderRadiusBase,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file_outlined),
                      AppSpacing.gapW12,
                      Expanded(child: Text(LocaleKeys.expensesAttachmentPlaceholder.tr())),
                    ],
                  ),
                ),
                AppSpacing.gapH24,
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => onEdit(expense.id),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(LocaleKeys.actionsEdit.tr()),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.read<ExpenseDetailsCubit>().voidExpense(),
                      icon: const Icon(Icons.delete_outline),
                      label: Text(LocaleKeys.expensesDelete.tr()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.error,
                        side: BorderSide(color: context.colors.error),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return context.colors.error.withValues(alpha: 0.10);
                          }
                          if (states.contains(WidgetState.pressed)) {
                            return context.colors.error.withValues(alpha: 0.18);
                          }
                          return null;
                        }),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => AppToast.info(
                        context,
                        LocaleKeys.expensesDuplicatePlaceholder.tr(),
                      ),
                      icon: const Icon(Icons.copy_outlined),
                      label: Text(LocaleKeys.actionsDuplicate.tr()),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => AppToast.info(
                        context,
                        LocaleKeys.expensesPrintPlaceholder.tr(),
                      ),
                      icon: const Icon(Icons.print_outlined),
                      label: Text(LocaleKeys.actionsPrint.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat.yMMMd().format(date);
  }

  String _categoryName(String? id) {
    for (final item in lookups.categories) {
      if (item.id == id) return item.name;
    }
    return '-';
  }

  String _vendorName(String? id) {
    for (final item in lookups.vendors) {
      if (item.id == id) return item.name;
    }
    return '-';
  }

  String _accountName(String? id) {
    final account = lookups.accountById(id);
    return account == null ? '-' : '${account.code} - ${account.name}';
  }

  String _taxName(String? id) {
    for (final item in lookups.taxes) {
      if (item.id == id) return item.name;
    }
    return '-';
  }

  String _recurrenceTypeLabel() {
    final type = expense.recurrenceType;
    if (type == null) return '';
    return switch (type) {
      RecurrenceType.daily => LocaleKeys.reportsDaily.tr(),
      RecurrenceType.weekly => LocaleKeys.reportsWeekly.tr(),
      RecurrenceType.monthly => LocaleKeys.reportsMonthly.tr(),
      RecurrenceType.yearly => LocaleKeys.reportsYearly.tr(),
    };
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive(mobile: double.infinity, tablet: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
          AppSpacing.gapH4,
          Text(value, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
