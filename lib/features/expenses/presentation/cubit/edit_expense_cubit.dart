import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/usecases/get_expense_details_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import 'add_expense_cubit.dart';

class EditExpenseCubit extends AddExpenseCubit {
  EditExpenseCubit({
    required super.loadLookupsUseCase,
    required super.addExpenseUseCase,
    required GetExpenseDetailsUseCase getExpenseDetailsUseCase,
    required UpdateExpenseUseCase updateExpenseUseCase,
  })  : _getExpenseDetailsUseCase = getExpenseDetailsUseCase,
        _updateExpenseUseCase = updateExpenseUseCase;

  final GetExpenseDetailsUseCase _getExpenseDetailsUseCase;
  final UpdateExpenseUseCase _updateExpenseUseCase;

  ExpenseEntity? _existingExpense;

  Future<void> loadExpense(String id) async {
    emit(state.copyWith(isLookupsLoading: true, clearErrorMessage: true));
    await loadLookups();

    final result = await _getExpenseDetailsUseCase(
      GetExpenseDetailsParams(id: id),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLookupsLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (expense) {
        _existingExpense = expense;
        emit(
          state.copyWith(
            isLookupsLoading: false,
            amount: expense.amount,
            currency: expense.currency,
            description: expense.description,
            clearDescription: expense.description == null,
            expenseDate: expense.expenseDate,
            clearExpenseDate: expense.expenseDate == null,
            code: expense.code,
            selectedCategory: _categoryById(expense.categoryId),
            clearSelectedCategory: expense.categoryId == null,
            selectedVendor: _vendorById(expense.vendorId),
            clearSelectedVendor: expense.vendorId == null,
            selectedPaidFromAccount: state.lookups.accountById(
              expense.paidFromAccountId,
            ),
            clearSelectedPaidFromAccount: expense.paidFromAccountId == null,
            selectedSubAccount: state.lookups.accountById(expense.subAccountId),
            clearSelectedSubAccount: expense.subAccountId == null,
            selectedTax: _taxById(expense.taxId),
            clearSelectedTax: expense.taxId == null,
            isRecurring: expense.isRecurring,
            recurrenceType: expense.recurrenceType,
            clearRecurrenceType: expense.recurrenceType == null,
            recurrenceEndDate: expense.recurrenceEndDate,
            clearRecurrenceEndDate: expense.recurrenceEndDate == null,
            attachmentUrl: expense.attachmentUrl,
            clearAttachmentUrl: expense.attachmentUrl == null,
          ),
        );
        generateJournalPreview();
      },
    );
  }

  @override
  Future<void> saveAsDraft() => _saveEdit(saveAsDraft: true);

  @override
  Future<void> saveExpense() => _saveEdit(saveAsDraft: false);

  Future<void> _saveEdit({required bool saveAsDraft}) async {
    final existing = _existingExpense;
    if (existing == null) return;

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

    final updated = buildExpenseEntity(
      status: saveAsDraft ? ExpenseStatus.draft : ExpenseStatus.saved,
    ).copyWith(
      id: existing.id,
      userId: existing.userId,
      journalEntryId: existing.journalEntryId,
      createdAt: existing.createdAt,
    );

    final result = await _updateExpenseUseCase(
      UpdateExpenseParams(expense: updated, saveAsDraft: saveAsDraft),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
          saveSuccess: false,
        ),
      ),
      (expense) {
        _existingExpense = expense;
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccess: true,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  ExpenseCategoryEntity? _categoryById(String? id) {
    if (id == null) return null;
    for (final category in state.lookups.categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  VendorEntity? _vendorById(String? id) {
    if (id == null) return null;
    for (final vendor in state.lookups.vendors) {
      if (vendor.id == id) return vendor;
    }
    return null;
  }

  TaxEntity? _taxById(String? id) {
    if (id == null) return null;
    for (final tax in state.lookups.taxes) {
      if (tax.id == id) return tax;
    }
    return null;
  }
}
