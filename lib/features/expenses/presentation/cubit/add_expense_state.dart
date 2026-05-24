import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/entities/vendor_entity.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../view_model/journal_preview_view_model.dart';

class AddExpenseState extends Equatable {
  const AddExpenseState({
    this.isLookupsLoading = false,
    this.lookups = ExpenseFormLookupsViewModel.empty,
    this.amount,
    this.currency = 'EGP',
    this.description,
    this.expenseDate,
    this.code,
    this.selectedCategory,
    this.selectedVendor,
    this.selectedPaidFromAccount,
    this.selectedSubAccount,
    this.selectedTax,
    this.isRecurring = false,
    this.recurrenceType,
    this.recurrenceEndDate,
    this.attachmentUrl,
    this.journalPreview = JournalPreviewViewModel.empty,
    this.validationErrors = const {},
    this.isSaving = false,
    this.saveSuccess = false,
    this.errorMessage,
  });

  final bool isLookupsLoading;
  final ExpenseFormLookupsViewModel lookups;
  final double? amount;
  final String currency;
  final String? description;
  final DateTime? expenseDate;
  final String? code;
  final ExpenseCategoryEntity? selectedCategory;
  final VendorEntity? selectedVendor;
  final AccountEntity? selectedPaidFromAccount;
  final AccountEntity? selectedSubAccount;
  final TaxEntity? selectedTax;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final DateTime? recurrenceEndDate;
  final String? attachmentUrl;
  final JournalPreviewViewModel journalPreview;
  final Map<String, String> validationErrors;
  final bool isSaving;
  final bool saveSuccess;
  final String? errorMessage;

  bool get isValid => validationErrors.isEmpty;

  AddExpenseState copyWith({
    bool? isLookupsLoading,
    ExpenseFormLookupsViewModel? lookups,
    double? amount,
    bool clearAmount = false,
    String? currency,
    String? description,
    bool clearDescription = false,
    DateTime? expenseDate,
    bool clearExpenseDate = false,
    String? code,
    bool clearCode = false,
    ExpenseCategoryEntity? selectedCategory,
    bool clearSelectedCategory = false,
    VendorEntity? selectedVendor,
    bool clearSelectedVendor = false,
    AccountEntity? selectedPaidFromAccount,
    bool clearSelectedPaidFromAccount = false,
    AccountEntity? selectedSubAccount,
    bool clearSelectedSubAccount = false,
    TaxEntity? selectedTax,
    bool clearSelectedTax = false,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    bool clearRecurrenceType = false,
    DateTime? recurrenceEndDate,
    bool clearRecurrenceEndDate = false,
    String? attachmentUrl,
    bool clearAttachmentUrl = false,
    JournalPreviewViewModel? journalPreview,
    Map<String, String>? validationErrors,
    bool? isSaving,
    bool? saveSuccess,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddExpenseState(
      isLookupsLoading: isLookupsLoading ?? this.isLookupsLoading,
      lookups: lookups ?? this.lookups,
      amount: clearAmount ? null : amount ?? this.amount,
      currency: currency ?? this.currency,
      description: clearDescription ? null : description ?? this.description,
      expenseDate: clearExpenseDate ? null : expenseDate ?? this.expenseDate,
      code: clearCode ? null : code ?? this.code,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      selectedVendor: clearSelectedVendor ? null : selectedVendor ?? this.selectedVendor,
      selectedPaidFromAccount: clearSelectedPaidFromAccount
          ? null
          : selectedPaidFromAccount ?? this.selectedPaidFromAccount,
      selectedSubAccount: clearSelectedSubAccount
          ? null
          : selectedSubAccount ?? this.selectedSubAccount,
      selectedTax: clearSelectedTax ? null : selectedTax ?? this.selectedTax,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: clearRecurrenceType
          ? null
          : recurrenceType ?? this.recurrenceType,
      recurrenceEndDate: clearRecurrenceEndDate
          ? null
          : recurrenceEndDate ?? this.recurrenceEndDate,
      attachmentUrl: clearAttachmentUrl ? null : attachmentUrl ?? this.attachmentUrl,
      journalPreview: journalPreview ?? this.journalPreview,
      validationErrors: validationErrors ?? this.validationErrors,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  static const fieldAmount = 'amount';
  static const fieldDate = 'expenseDate';
  static const fieldCategory = 'category';
  static const fieldPaidFromAccount = 'paidFromAccount';

  @override
  List<Object?> get props => [
        isLookupsLoading,
        lookups,
        amount,
        currency,
        description,
        expenseDate,
        code,
        selectedCategory,
        selectedVendor,
        selectedPaidFromAccount,
        selectedSubAccount,
        selectedTax,
        isRecurring,
        recurrenceType,
        recurrenceEndDate,
        attachmentUrl,
        journalPreview,
        validationErrors,
        isSaving,
        saveSuccess,
        errorMessage,
      ];
}
