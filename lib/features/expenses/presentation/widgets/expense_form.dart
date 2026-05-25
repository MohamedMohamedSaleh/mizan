import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/entities/vendor_entity.dart';
import '../cubit/add_expense_cubit.dart';
import '../cubit/add_expense_state.dart';

class ExpenseForm extends StatelessWidget {
  const ExpenseForm({
    super.key,
    required this.state,
    required this.cubit,
    this.showSavedWarning = false,
    this.onCancel,
  });

  final AddExpenseState state;
  final AddExpenseCubit cubit;
  final bool showSavedWarning;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    if (state.isLookupsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasRequiredLookups =
        state.lookups.categories.isNotEmpty && state.lookups.paymentAccounts.isNotEmpty;

    return SingleChildScrollView(
      padding: context.responsive(
        mobile: AppSpacing.pagePaddingMobile,
        tablet: AppSpacing.pagePaddingTablet,
        desktop: AppSpacing.pagePaddingDesktop,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!hasRequiredLookups) _LookupEmptyCard(onSeed: cubit.loadLookups),
              if (showSavedWarning) ...[
                _InfoCard(
                  icon: Icons.info_outline,
                  text: LocaleKeys.expensesSavedWarning.tr(),
                ),
                AppSpacing.gapH16,
              ],
              _Card(
                child: Column(
                  children: [
                    _responsiveRow(
                      context,
                      _AmountField(state: state, cubit: cubit),
                      _Dropdown<String>(
                        label: LocaleKeys.expensesCurrency.tr(),
                        value: state.currency,
                        items: const ['EGP', 'USD', 'EUR', 'SAR'],
                        itemLabel: (value) => value,
                        onChanged: (_) {},
                      ),
                    ),
                    AppSpacing.gapH16,
                    _responsiveRow(
                      context,
                      _TextField(
                        label: LocaleKeys.expensesCode.tr(),
                        initialValue: state.code,
                        readOnly: true,
                      ),
                      _DateField(
                        label: LocaleKeys.expensesDate.tr(),
                        value: state.expenseDate,
                        errorKey: state.validationErrors[AddExpenseState.fieldDate],
                        onChanged: cubit.dateChanged,
                      ),
                    ),
                    AppSpacing.gapH16,
                    _TextField(
                      label: LocaleKeys.expensesDescription.tr(),
                      initialValue: state.description,
                      maxLines: 3,
                      onChanged: cubit.descriptionChanged,
                    ),
                    AppSpacing.gapH16,
                    _responsiveRow(
                      context,
                      _Dropdown<ExpenseCategoryEntity>(
                        label: LocaleKeys.expensesCategory.tr(),
                        hint: LocaleKeys.expensesSelectCategory.tr(),
                        value: state.selectedCategory,
                        items: state.lookups.categories,
                        itemLabel: (item) => item.name,
                        errorKey:
                            state.validationErrors[AddExpenseState.fieldCategory],
                        onChanged: cubit.categoryChanged,
                      ),
                      _Dropdown<VendorEntity>(
                        label: LocaleKeys.expensesVendor.tr(),
                        hint: LocaleKeys.expensesSelectVendor.tr(),
                        value: state.selectedVendor,
                        items: state.lookups.vendors,
                        itemLabel: (item) => item.name,
                        showClear: true,
                        onChanged: cubit.vendorChanged,
                      ),
                    ),
                    AppSpacing.gapH16,
                    _responsiveRow(
                      context,
                      _Dropdown<AccountEntity>(
                        label: LocaleKeys.expensesPaidFrom.tr(),
                        hint: LocaleKeys.expensesSelectPaidAccount.tr(),
                        value: state.selectedPaidFromAccount,
                        items: state.lookups.paymentAccounts,
                        itemLabel: (item) => '${item.code} - ${item.name}',
                        errorKey: state.validationErrors[
                            AddExpenseState.fieldPaidFromAccount],
                        onChanged: cubit.paidFromAccountChanged,
                      ),
                      _Dropdown<AccountEntity>(
                        label: LocaleKeys.expensesSubAccount.tr(),
                        hint: LocaleKeys.expensesSelectSubAccount.tr(),
                        value: state.selectedSubAccount,
                        items: state.lookups.accounts,
                        itemLabel: (item) => '${item.code} - ${item.name}',
                        showClear: true,
                        onChanged: cubit.subAccountChanged,
                      ),
                    ),
                    AppSpacing.gapH16,
                    _responsiveRow(
                      context,
                      _Dropdown<TaxEntity>(
                        label: LocaleKeys.expensesTax.tr(),
                        hint: LocaleKeys.expensesSelectTax.tr(),
                        value: state.selectedTax,
                        items: state.lookups.taxes,
                        itemLabel: (item) => '${item.name} (${item.rate}%)',
                        showClear: true,
                        onChanged: cubit.taxChanged,
                      ),
                      _AttachmentPlaceholder(),
                    ),
                    AppSpacing.gapH16,
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: state.isRecurring,
                      onChanged: (value) => cubit.recurringChanged(value ?? false),
                      title: Text(LocaleKeys.expensesRecurring.tr()),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (state.isRecurring) ...[
                      AppSpacing.gapH8,
                      _responsiveRow(
                        context,
                        _Dropdown<RecurrenceType>(
                          label: LocaleKeys.expensesRecurrenceType.tr(),
                          value: state.recurrenceType,
                          items: RecurrenceType.values,
                          itemLabel: (item) => _recurrenceTypeLabel(item),
                          onChanged: cubit.recurrenceTypeChanged,
                        ),
                        _DateField(
                          label: LocaleKeys.expensesRecurrenceEndDate.tr(),
                          value: state.recurrenceEndDate,
                          onChanged: cubit.recurrenceEndDateChanged,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.gapH16,
              if (state.journalPreview.lines.isNotEmpty) _JournalPreview(state),
              AppSpacing.gapH24,
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: state.isSaving ? null : onCancel,
                    icon: const Icon(Icons.close),
                    label: Text(LocaleKeys.expensesCancel.tr()),
                  ),
                  OutlinedButton.icon(
                    onPressed: state.isSaving ? null : cubit.saveAsDraft,
                    icon: const Icon(Icons.description_outlined),
                    label: Text(LocaleKeys.expensesSaveDraft.tr()),
                  ),
                  ElevatedButton.icon(
                    onPressed: state.isSaving ? null : cubit.saveExpense,
                    icon: state.isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(LocaleKeys.expensesSave.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _responsiveRow(BuildContext context, Widget first, Widget second) {
    if (context.isMobile) {
      return Column(
        children: [first, AppSpacing.gapH16, second],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        AppSpacing.gapW16,
        Expanded(child: second),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Icon(icon, color: context.colors.info),
          AppSpacing.gapW12,
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _LookupEmptyCard extends StatelessWidget {
  const _LookupEmptyCard({required this.onSeed});
  final VoidCallback onSeed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: _Card(
        child: Row(
          children: [
            Icon(Icons.account_tree_outlined, color: context.colors.warning),
            AppSpacing.gapW12,
            Expanded(child: Text(LocaleKeys.expensesNoLookups.tr())),
            OutlinedButton.icon(
              onPressed: onSeed,
              icon: const Icon(Icons.auto_fix_high_outlined),
              label: Text(LocaleKeys.expensesSeedData.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.state, required this.cubit});
  final AddExpenseState state;
  final AddExpenseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return _TextField(
      label: LocaleKeys.expensesAmount.tr(),
      initialValue: state.amount?.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      errorKey: state.validationErrors[AddExpenseState.fieldAmount],
      textStyle: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      onChanged: (value) => cubit.amountChanged(double.tryParse(value)),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.maxLines = 1,
    this.errorKey,
    this.textStyle,
  });
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int maxLines;
  final String? errorKey;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      maxLines: maxLines,
      style: textStyle,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorKey?.tr(),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hint,
    this.errorKey,
    this.showClear = false,
  });
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? errorKey;
  final bool showClear;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorKey?.tr(),
        suffixIcon: showClear && value != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => onChanged(null),
              )
            : null,
      ),
      hint: hint?.isEmpty ?? true ? null : Text(hint!),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorKey,
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? errorKey;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorKey?.tr(),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(value == null ? '' : DateFormat.yMMMd().format(value!)),
      ),
    );
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: LocaleKeys.expensesAttachment.tr()),
      child: Row(
        children: [
          Icon(Icons.attach_file_outlined, color: context.colors.textSecondary),
          AppSpacing.gapW8,
          Expanded(child: Text(LocaleKeys.expensesAttachmentPlaceholder.tr())),
        ],
      ),
    );
  }
}

class _JournalPreview extends StatelessWidget {
  const _JournalPreview(this.state);
  final AddExpenseState state;
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.expensesJournalPreview.tr(),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.gapH12,
          ...state.journalPreview.lines.map(
            (line) => Padding(
              padding: AppSpacing.paddingVSm,
              child: Row(
                children: [
                  Expanded(child: Text(line.accountName)),
                  Text('${line.debit.toStringAsFixed(2)} / ${line.credit.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(child: Text(LocaleKeys.accountingBalanced.tr())),
              Icon(
                state.journalPreview.isBalanced
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: state.journalPreview.isBalanced
                    ? context.colors.success
                    : context.colors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _recurrenceTypeLabel(RecurrenceType type) => switch (type) {
      RecurrenceType.daily => LocaleKeys.reportsDaily.tr(),
      RecurrenceType.weekly => LocaleKeys.reportsWeekly.tr(),
      RecurrenceType.monthly => LocaleKeys.reportsMonthly.tr(),
      RecurrenceType.yearly => LocaleKeys.reportsYearly.tr(),
    };
