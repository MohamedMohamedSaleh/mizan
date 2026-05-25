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
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../cubit/expenses_cubit.dart';
import '../cubit/expenses_state.dart';
import '../view_model/expense_filter_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../view_model/expense_list_item_view_model.dart';
import '../widgets/expense_status_badge.dart';
import '../widgets/expense_summary_card.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<ExpenseListItemViewModel> _cachedExpenses = const [];
  ExpenseFilterViewModel _cachedFilters = const ExpenseFilterViewModel();
  ExpenseFormLookupsViewModel _cachedLookups =
      ExpenseFormLookupsViewModel.empty;

  @override
  void initState() {
    super.initState();
    context.read<ExpensesCubit>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpensesCubit, ExpensesState>(
      listener: (context, state) {
        if (state is ExpensesError) AppToast.error(context, state.message);
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBar(title: Text(LocaleKeys.expensesTitle.tr()))
            : null,
        floatingActionButton: context.isMobile
            ? BlocBuilder<ExpensesCubit, ExpensesState>(
                builder: (context, state) {
                  final lookups = switch (state) {
                    ExpensesLoaded loaded => loaded.lookups,
                    ExpensesEmpty empty => empty.lookups,
                    _ => null,
                  };
                  return FloatingActionButton(
                    onPressed: lookups == null
                        ? null
                        : () => _openAddExpense(context, lookups),
                    child: const Icon(Icons.add),
                  );
                },
              )
            : null,
        body: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (context, state) {
            if (state is ExpensesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpensesLoading) {
              if (_cachedLookups == ExpenseFormLookupsViewModel.empty) {
                return const Center(child: CircularProgressIndicator());
              }
              return _ExpensesBody(
                expenses: _cachedExpenses,
                filters: _cachedFilters,
                lookups: _cachedLookups,
                isSectionLoading: true,
              );
            }
            if (state is ExpensesLoaded) {
              _cachedExpenses = state.expenses;
              _cachedFilters = state.filters;
              _cachedLookups = state.lookups;
              return _ExpensesBody(
                expenses: state.expenses,
                filters: state.filters,
                lookups: state.lookups,
              );
            }
            if (state is ExpensesEmpty) {
              _cachedExpenses = const [];
              _cachedFilters = state.filters;
              _cachedLookups = state.lookups;
              return _ExpensesBody(
                expenses: const [],
                filters: state.filters,
                lookups: state.lookups,
              );
            }
            return Center(child: Text(LocaleKeys.messagesError.tr()));
          },
        ),
      ),
    );
  }
}

class _ExpensesBody extends StatelessWidget {
  const _ExpensesBody({
    required this.expenses,
    required this.filters,
    required this.lookups,
    this.isSectionLoading = false,
  });

  final List<ExpenseListItemViewModel> expenses;
  final ExpenseFilterViewModel filters;
  final ExpenseFormLookupsViewModel lookups;
  final bool isSectionLoading;

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive(
      mobile: AppSpacing.pagePaddingMobile,
      tablet: AppSpacing.pagePaddingTablet,
      desktop: AppSpacing.pagePaddingDesktop,
    );

    return RefreshIndicator(
      onRefresh: context.read<ExpensesCubit>().refresh,
      child: ListView(
        padding: padding,
        children: [
          if (!context.isMobile) _Header(lookups: lookups),
          AppSpacing.gapH32,
          _SummaryStrip(expenses: expenses),
          AppSpacing.gapH24,
          if (context.isMobile)
            _MobileSearch(filters: filters, lookups: lookups)
          else
            _FilterPanel(filters: filters, lookups: lookups),
          AppSpacing.gapH16,
          if (isSectionLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          if (expenses.isEmpty)
            _EmptyState()
          else if (context.isMobile)
            ...expenses.map(
              (expense) => _ExpenseCard(expense: expense, lookups: lookups),
            )
          else
            _ExpensesTable(expenses: expenses, lookups: lookups),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.lookups});

  final ExpenseFormLookupsViewModel lookups;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.expensesTitle.tr(),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddExpense(context, lookups),
          icon: const Icon(Icons.add),
          label: Text(LocaleKeys.expensesAdd.tr()),
        ),
      ],
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.expenses});
  final List<ExpenseListItemViewModel> expenses;
  @override
  Widget build(BuildContext context) {
    final last7Days = _summarySince(const Duration(days: 7));
    final last30Days = _summarySince(const Duration(days: 30));
    final last365Days = _summarySince(const Duration(days: 365));

    final cards = [
      ExpenseSummaryCard(
        title: LocaleKeys.expensesSummaryLast7Days.tr(context: context),
        amount: last7Days.amount,
        currency: last7Days.currency,
        icon: Icons.today_outlined,
      ),
      ExpenseSummaryCard(
        title: LocaleKeys.expensesSummaryLast30Days.tr(context: context),
        amount: last30Days.amount,
        currency: last30Days.currency,
        icon: Icons.date_range_outlined,
      ),
      ExpenseSummaryCard(
        title: LocaleKeys.expensesSummaryLast365Days.tr(context: context),
        amount: last365Days.amount,
        currency: last365Days.currency,
        icon: Icons.calendar_month_outlined,
        endPadding: 0,
      ),
    ];
    if (context.isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: cards.map((card) => card).toList()),
      );
    }
    return Row(children: cards.map((card) => Expanded(child: card)).toList());
  }

  _SummaryMetric _summarySince(Duration duration) {
    final threshold = DateTime.now().subtract(duration);
    final rangedExpenses = expenses.where((expense) {
      final date = expense.expenseDate;
      return date != null && date.isAfter(threshold);
    }).toList();

    final amount = rangedExpenses
        .fold(0.0, (sum, expense) => sum + expense.amount);

    final currencies = rangedExpenses
        .where((expense) {
          final currency = expense.currency.trim();
          return currency.isNotEmpty;
        })
        .map((expense) => expense.currency.toUpperCase())
        .toSet();

    final currency = currencies.isEmpty ? 'SAR' : currencies.join(', ');

    return _SummaryMetric(amount: amount, currency: currency);
  }
}

class _SummaryMetric {
  const _SummaryMetric({required this.amount, required this.currency});

  final double amount;
  final String currency;
}

class _MobileSearch extends StatelessWidget {
  const _MobileSearch({required this.filters, required this.lookups});
  final ExpenseFilterViewModel filters;
  final ExpenseFormLookupsViewModel lookups;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SearchField(filters: filters)),
        AppSpacing.gapW8,
        IconButton.filledTonal(
          onPressed: () {
            final expensesCubit = context.read<ExpensesCubit>();
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: expensesCubit,
                child: _MobileFilterSheet(
                  initialFilters: filters,
                  lookups: lookups,
                ),
              ),
            );
          },
          icon: const Icon(Icons.filter_list),
          tooltip: LocaleKeys.expensesFilters.tr(),
        ),
      ],
    );
  }
}

class _MobileFilterSheet extends StatefulWidget {
  const _MobileFilterSheet({
    required this.initialFilters,
    required this.lookups,
  });

  final ExpenseFilterViewModel initialFilters;
  final ExpenseFormLookupsViewModel lookups;

  @override
  State<_MobileFilterSheet> createState() => _MobileFilterSheetState();
}

class _MobileFilterSheetState extends State<_MobileFilterSheet> {
  late String? _categoryId;
  late ExpenseStatus? _status;
  late DateTime? _fromDate;
  late DateTime? _toDate;

  bool get _hasActiveFilters =>
      _categoryId != null || _status != null || _fromDate != null || _toDate != null;

  ExpenseFilterViewModel get _draftFilters => widget.initialFilters.copyWith(
        categoryId: _categoryId,
        clearCategoryId: _categoryId == null,
        status: _status,
        clearStatus: _status == null,
        fromDate: _fromDate,
        clearFromDate: _fromDate == null,
        toDate: _toDate,
        clearToDate: _toDate == null,
      );

  @override
  void initState() {
    super.initState();
    _categoryId = widget.initialFilters.categoryId;
    _status = widget.initialFilters.status;
    _fromDate = widget.initialFilters.fromDate;
    _toDate = widget.initialFilters.toDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterPanel(
              filters: _draftFilters,
              lookups: widget.lookups,
              showSearchField: false,
              onCategoryChanged: (value) => setState(() => _categoryId = value),
              onStatusChanged: (value) => setState(() => _status = value),
              onFromDateChanged: (value) => setState(() => _fromDate = value),
              onToDateChanged: (value) => setState(() => _toDate = value),
              onClearFilters: _hasActiveFilters
                  ? () {
                      setState(() {
                        _categoryId = null;
                        _status = null;
                        _fromDate = null;
                        _toDate = null;
                      });
                    }
                  : null,
            ),
            AppSpacing.gapH12,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<ExpensesCubit>().applyFilters(
                        categoryId: _categoryId,
                        clearCategoryId: _categoryId == null,
                        status: _status,
                        clearStatus: _status == null,
                        fromDate: _fromDate,
                        clearFromDate: _fromDate == null,
                        toDate: _toDate,
                        clearToDate: _toDate == null,
                      );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
                label: Text(LocaleKeys.actionsConfirm.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.filters,
    required this.lookups,
    this.showSearchField = true,
    this.onCategoryChanged,
    this.onStatusChanged,
    this.onFromDateChanged,
    this.onToDateChanged,
    this.onClearFilters,
  });
  final ExpenseFilterViewModel filters;
  final ExpenseFormLookupsViewModel lookups;
  final bool showSearchField;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<ExpenseStatus?>? onStatusChanged;
  final ValueChanged<DateTime?>? onFromDateChanged;
  final ValueChanged<DateTime?>? onToDateChanged;
  final VoidCallback? onClearFilters;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (showSearchField)
            SizedBox(width: 280, child: _SearchField(filters: filters)),
          SizedBox(
            width: 180,
            child: _CategoryFilter(
              filters: filters,
              categories: lookups.categories,
              onChanged: onCategoryChanged,
            ),
          ),
          SizedBox(
            width: 160,
            child: _StatusFilter(
              filters: filters,
              onChanged: onStatusChanged,
            ),
          ),
          _FilterDateButton(
            label: LocaleKeys.fieldsFromDate.tr(),
            value: filters.fromDate,
            onChanged: onFromDateChanged ??
                (date) => context.read<ExpensesCubit>().applyFilters(
                      fromDate: date,
                      clearFromDate: date == null,
                    ),
          ),
          _FilterDateButton(
            label: LocaleKeys.fieldsToDate.tr(),
            value: filters.toDate,
            onChanged: onToDateChanged ??
                (date) => context.read<ExpensesCubit>().applyFilters(
                      toDate: date,
                      clearToDate: date == null,
                    ),
          ),
          OutlinedButton.icon(
            onPressed: onClearFilters ??
                (filters.hasActiveFilters
                    ? context.read<ExpensesCubit>().clearFilters
                    : null),
            icon: const Icon(Icons.clear),
            label: Text(LocaleKeys.expensesClearFilters.tr()),
          ),
        ],
      ),
    );
  }
}

class _FilterDateButton extends StatelessWidget {
  const _FilterDateButton({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      icon: const Icon(Icons.calendar_today_outlined),
      label: Text(value == null ? label : DateFormat.yMMMd().format(value!)),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.filters});
  final ExpenseFilterViewModel filters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: filters.search,
      decoration: InputDecoration(
        hintText: LocaleKeys.expensesSearchHint.tr(),
        prefixIcon: const Icon(Icons.search),
      ),
      onFieldSubmitted: context.read<ExpensesCubit>().search,
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.filters,
    required this.categories,
    this.onChanged,
  });
  final ExpenseFilterViewModel filters;
  final List<ExpenseCategoryEntity> categories;
  final ValueChanged<String?>? onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey(filters.categoryId),
      initialValue: filters.categoryId,
      isExpanded: true,
      decoration: InputDecoration(labelText: LocaleKeys.expensesCategory.tr()),
      items: categories
          .map(
            (item) => DropdownMenuItem(value: item.id, child: Text(item.name)),
          )
          .toList(),
      onChanged: onChanged ??
          (value) => context.read<ExpensesCubit>().applyFilters(
                categoryId: value,
                clearCategoryId: value == null,
              ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.filters, this.onChanged});
  final ExpenseFilterViewModel filters;
  final ValueChanged<ExpenseStatus?>? onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ExpenseStatus>(
      key: ValueKey(filters.status),
      initialValue: filters.status,
      isExpanded: true,
      decoration: InputDecoration(labelText: LocaleKeys.expensesStatus.tr()),
      items: ExpenseStatus.values
          .map(
            (item) =>
                DropdownMenuItem(value: item, child: Text(_statusLabel(item))),
          )
          .toList(),
      onChanged: onChanged ??
          (value) => context.read<ExpensesCubit>().applyFilters(
                status: value,
                clearStatus: value == null,
              ),
    );
  }
}

class _ExpensesTable extends StatelessWidget {
  const _ExpensesTable({required this.expenses, required this.lookups});
  final List<ExpenseListItemViewModel> expenses;
  final ExpenseFormLookupsViewModel lookups;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(LocaleKeys.expensesCode.tr())),
            DataColumn(label: Text(LocaleKeys.expensesDate.tr())),
            DataColumn(label: Text(LocaleKeys.expensesDescription.tr())),
            DataColumn(label: Text(LocaleKeys.expensesCategory.tr())),
            DataColumn(label: Text(LocaleKeys.expensesAmount.tr())),
            DataColumn(label: Text(LocaleKeys.expensesStatus.tr())),
            DataColumn(label: Text(LocaleKeys.actionsEdit.tr())),
          ],
          rows: expenses
              .map(
                (expense) => DataRow(
                  cells: [
                    DataCell(Text(expense.code)),
                    DataCell(Text(_formatDate(expense.expenseDate))),
                    DataCell(Text(expense.description ?? '-')),
                    DataCell(Text(_categoryName(expense.categoryId, lookups))),
                    DataCell(Text(_amount(expense))),
                    DataCell(ExpenseStatusBadge(status: expense.status)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _openExpenseDetails(context, expense.id),
                            icon: const Icon(Icons.visibility_outlined),
                          ),
                          IconButton(
                            onPressed: () =>
                                _openEditExpense(context, expense.id),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: () =>
                                _confirmDelete(context, expense.id),
                            icon: const Icon(Icons.delete_outline),
                            color: context.colors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.expense, required this.lookups});
  final ExpenseListItemViewModel expense;
  final ExpenseFormLookupsViewModel lookups;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => _openExpenseDetails(context, expense.id),
        borderRadius: AppRadius.borderRadiusBase,
        child: Container(
          padding: AppSpacing.paddingAllLg,
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
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  ExpenseStatusBadge(status: expense.status),
                ],
              ),
              AppSpacing.gapH8,
              Text(
                expense.description ??
                    _categoryName(expense.categoryId, lookups),
              ),
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(child: Text(_formatDate(expense.expenseDate))),
                  Text(
                    _amount(expense),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _openEditExpense(context, expense.id),
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: LocaleKeys.actionsEdit.tr(),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, expense.id),
                    icon: const Icon(Icons.delete_outline),
                    color: context.colors.error,
                    tooltip: LocaleKeys.expensesDelete.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllXl,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: context.colors.textSecondary,
          ),
          AppSpacing.gapH12,
          Text(LocaleKeys.expensesNoExpenses.tr()),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? date) =>
    date == null ? '-' : DateFormat.yMMMd().format(date);

String _amount(ExpenseListItemViewModel expense) =>
    '${NumberFormat.currency(symbol: '', decimalDigits: 2).format(expense.amount)} ${expense.currency}';

String _categoryName(String? categoryId, ExpenseFormLookupsViewModel lookups) {
  for (final category in lookups.categories) {
    if (category.id == categoryId) return category.name;
  }
  return '-';
}

String _statusLabel(ExpenseStatus status) => switch (status) {
  ExpenseStatus.draft => LocaleKeys.expensesStatusDraft.tr(),
  ExpenseStatus.saved => LocaleKeys.expensesStatusSaved.tr(),
  ExpenseStatus.voided => LocaleKeys.expensesStatusVoided.tr(),
};

Future<void> _confirmDelete(BuildContext context, String id) async {
  final expensesCubit = context.read<ExpensesCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(LocaleKeys.expensesDelete.tr()),
      content: Text(LocaleKeys.expensesConfirmDelete.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(LocaleKeys.actionsCancel.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(LocaleKeys.actionsConfirm.tr()),
        ),
      ],
    ),
  );

  if (confirmed ?? false) {
    await expensesCubit.deleteExpense(id);
  }
}

Future<void> _openAddExpense(
  BuildContext context,
  ExpenseFormLookupsViewModel lookups,
) async {
  final shouldRefresh = await context.push<bool>(
    RoutePaths.addExpense,
    extra: lookups,
  );
  if (shouldRefresh == true && context.mounted) {
    await context.read<ExpensesCubit>().refresh();
  }
}

Future<void> _openEditExpense(BuildContext context, String expenseId) async {
  final shouldRefresh = await context.push<bool>(
    '/dashboard/expenses/$expenseId/edit',
  );
  if (shouldRefresh == true && context.mounted) {
    await context.read<ExpensesCubit>().refresh();
  }
}

Future<void> _openExpenseDetails(BuildContext context, String expenseId) async {
  final shouldRefresh = await context.push<bool>(
    '/dashboard/expenses/$expenseId',
  );
  if (shouldRefresh == true && context.mounted) {
    await context.read<ExpensesCubit>().refresh();
  }
}
