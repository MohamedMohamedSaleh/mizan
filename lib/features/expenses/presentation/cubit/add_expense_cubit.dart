import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/load_expense_form_lookups_usecase.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../view_model/journal_preview_view_model.dart';
import 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit({
    required LoadExpenseFormLookupsUseCase loadLookupsUseCase,
    required AddExpenseUseCase addExpenseUseCase,
  })  : _loadLookupsUseCase = loadLookupsUseCase,
        _addExpenseUseCase = addExpenseUseCase,
        super(AddExpenseState(code: _generateCode(), expenseDate: DateTime.now()));

  final LoadExpenseFormLookupsUseCase _loadLookupsUseCase;
  final AddExpenseUseCase _addExpenseUseCase;

  Future<void> loadLookups({
    ExpenseFormLookupsViewModel? preloadedLookups,
    bool forceRefresh = false,
  }) async {
    if (preloadedLookups != null &&
        preloadedLookups != ExpenseFormLookupsViewModel.empty &&
        !forceRefresh) {
      emit(
        state.copyWith(
          isLookupsLoading: false,
          lookups: preloadedLookups,
          clearErrorMessage: true,
        ),
      );
      generateJournalPreview();
      return;
    }

    if (state.lookups != ExpenseFormLookupsViewModel.empty && !forceRefresh) {
      return;
    }

    emit(state.copyWith(isLookupsLoading: true, clearErrorMessage: true));
    final result = await _loadLookupsUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLookupsLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (lookups) => emit(
        state.copyWith(
          isLookupsLoading: false,
          lookups: ExpenseFormLookupsViewModel.fromEntity(lookups),
        ),
      ),
    );
    generateJournalPreview();
  }

  void amountChanged(double? amount) {
    emit(
      state.copyWith(
        amount: amount,
        clearAmount: amount == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
    generateJournalPreview();
  }

  void descriptionChanged(String value) {
    emit(
      state.copyWith(
        description: value.trim().isEmpty ? null : value,
        clearDescription: value.trim().isEmpty,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void dateChanged(DateTime? date) {
    emit(
      state.copyWith(
        expenseDate: date,
        clearExpenseDate: date == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void categoryChanged(ExpenseCategoryEntity? category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        clearSelectedCategory: category == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
    generateJournalPreview();
  }

  void vendorChanged(VendorEntity? vendor) {
    emit(
      state.copyWith(
        selectedVendor: vendor,
        clearSelectedVendor: vendor == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void paidFromAccountChanged(AccountEntity? account) {
    emit(
      state.copyWith(
        selectedPaidFromAccount: account,
        clearSelectedPaidFromAccount: account == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
    generateJournalPreview();
  }

  void subAccountChanged(AccountEntity? account) {
    emit(
      state.copyWith(
        selectedSubAccount: account,
        clearSelectedSubAccount: account == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void taxChanged(TaxEntity? tax) {
    emit(
      state.copyWith(
        selectedTax: tax,
        clearSelectedTax: tax == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void recurringChanged(bool isRecurring) {
    emit(
      state.copyWith(
        isRecurring: isRecurring,
        clearRecurrenceType: !isRecurring,
        clearRecurrenceEndDate: !isRecurring,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void recurrenceTypeChanged(RecurrenceType? type) {
    emit(
      state.copyWith(
        recurrenceType: type,
        clearRecurrenceType: type == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void recurrenceEndDateChanged(DateTime? date) {
    emit(
      state.copyWith(
        recurrenceEndDate: date,
        clearRecurrenceEndDate: date == null,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );
  }

  void generateJournalPreview() {
    final amount = state.amount ?? 0;
    final categoryAccount = state.lookups.expenseAccountForCategory(
      state.selectedCategory?.id,
    );
    final paidFromAccount = state.selectedPaidFromAccount;

    if (amount <= 0 || categoryAccount == null || paidFromAccount == null) {
      emit(state.copyWith(journalPreview: JournalPreviewViewModel.empty));
      return;
    }

    emit(
      state.copyWith(
        journalPreview: JournalPreviewViewModel(
          totalDebit: amount,
          totalCredit: amount,
          isBalanced: true,
          lines: [
            JournalPreviewLineViewModel(
              accountId: categoryAccount.id,
              accountName: categoryAccount.name,
              debit: amount,
              credit: 0,
            ),
            JournalPreviewLineViewModel(
              accountId: paidFromAccount.id,
              accountName: paidFromAccount.name,
              debit: 0,
              credit: amount,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveAsDraft() => _save(saveAsDraft: true);

  Future<void> saveExpense() => _save(saveAsDraft: false);

  Future<void> _save({required bool saveAsDraft}) async {
    final errors = validateForm();
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        saveSuccess: false,
        validationErrors: const {},
        clearErrorMessage: true,
      ),
    );

    final result = await _addExpenseUseCase(
      AddExpenseParams(
        expense: buildExpenseEntity(
          status: saveAsDraft ? ExpenseStatus.draft : ExpenseStatus.saved,
        ),
        saveAsDraft: saveAsDraft,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
          saveSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          saveSuccess: true,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Map<String, String> validateForm() {
    final errors = <String, String>{};
    if ((state.amount ?? 0) <= 0) {
      errors[AddExpenseState.fieldAmount] =
          LocaleKeys.expensesValidationAmountRequired;
    }
    if (state.expenseDate == null) {
      errors[AddExpenseState.fieldDate] =
          LocaleKeys.expensesValidationDateRequired;
    }
    if (state.selectedCategory == null) {
      errors[AddExpenseState.fieldCategory] =
          LocaleKeys.expensesValidationCategoryRequired;
    }
    if (state.selectedPaidFromAccount == null) {
      errors[AddExpenseState.fieldPaidFromAccount] =
          LocaleKeys.expensesValidationPaidFromRequired;
    }
    return errors;
  }

  ExpenseEntity buildExpenseEntity({required ExpenseStatus status}) {
    return ExpenseEntity(
      id: '',
      userId: '',
      code: state.code ?? _generateCode(),
      amount: state.amount ?? 0,
      currency: state.currency,
      description: state.description,
      expenseDate: state.expenseDate,
      categoryId: state.selectedCategory?.id,
      vendorId: state.selectedVendor?.id,
      paidFromAccountId: state.selectedPaidFromAccount?.id,
      subAccountId: state.selectedSubAccount?.id,
      taxId: state.selectedTax?.id,
      status: status,
      isRecurring: state.isRecurring,
      recurrenceType: state.recurrenceType,
      recurrenceEndDate: state.recurrenceEndDate,
      attachmentUrl: state.attachmentUrl,
    );
  }

  static String _generateCode() {
    return 'EXP-${DateTime.now().millisecondsSinceEpoch}';
  }
}
