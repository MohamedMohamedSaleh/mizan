import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/expense_category_entity.dart';
import '../entities/expense_entity.dart';
import '../entities/expense_enums.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/expense_categories_repository.dart';
import '../repositories/expenses_repository.dart';
import '../repositories/journal_entries_repository.dart';
import 'expense_journal_builder.dart';

class AddExpenseUseCase extends UseCase<ExpenseEntity, AddExpenseParams> {
  AddExpenseUseCase({
    required ExpensesRepository expensesRepository,
    required ExpenseCategoriesRepository categoriesRepository,
    required JournalEntriesRepository journalEntriesRepository,
  })  : _expensesRepository = expensesRepository,
        _categoriesRepository = categoriesRepository,
        _journalEntriesRepository = journalEntriesRepository;

  final ExpensesRepository _expensesRepository;
  final ExpenseCategoriesRepository _categoriesRepository;
  final JournalEntriesRepository _journalEntriesRepository;

  @override
  Future<Result<ExpenseEntity>> call(AddExpenseParams params) async {
    final validation = validateExpenseForSave(params.expense);
    if (validation is Error<void>) return Error(validation.failure);

    if (params.saveAsDraft) {
      return _expensesRepository.createExpense(
        params.expense.copyWith(
          status: ExpenseStatus.draft,
          clearJournalEntryId: true,
          clearDeletedAt: true,
        ),
      );
    }

    final categoryResult = await _findCategory(params.expense.categoryId!);
    if (categoryResult is Error<ExpenseCategoryEntity>) {
      return Error(categoryResult.failure);
    }
    final category = (categoryResult as Success<ExpenseCategoryEntity>).data;

    final bundleResult = buildExpenseJournalBundle(
      expense: params.expense,
      category: category,
    );
    if (bundleResult is Error<ExpenseJournalBundle>) {
      return Error(bundleResult.failure);
    }
    final bundle = (bundleResult as Success<ExpenseJournalBundle>).data;

    // TODO: Replace this multi-table save flow with a Postgres RPC transaction.
    final entryResult = await _journalEntriesRepository.createJournalEntry(
      bundle.entry,
    );
    if (entryResult is Error<JournalEntryEntity>) {
      return Error(entryResult.failure);
    }
    final entry = (entryResult as Success<JournalEntryEntity>).data;

    final lines = bundle.lines
        .map((line) => line.copyWith(journalEntryId: entry.id))
        .toList();
    final linesResult = await _journalEntriesRepository.createJournalEntryLines(
      lines,
    );
    if (linesResult is Error<void>) return Error(linesResult.failure);

    return _expensesRepository.createExpense(
      params.expense.copyWith(
        status: ExpenseStatus.saved,
        journalEntryId: entry.id,
        clearDeletedAt: true,
      ),
    );
  }

  Future<Result<ExpenseCategoryEntity>> _findCategory(String categoryId) async {
    final categoriesResult = await _categoriesRepository.getCategories();
    return categoriesResult.fold(
      Error.new,
      (categories) {
        for (final category in categories) {
          if (category.id == categoryId) return Success(category);
        }
        return const Error(
          UnexpectedFailure(message: 'Selected category was not found.'),
        );
      },
    );
  }
}

class AddExpenseParams extends Equatable {
  const AddExpenseParams({
    required this.expense,
    this.saveAsDraft = false,
  });

  final ExpenseEntity expense;
  final bool saveAsDraft;

  @override
  List<Object?> get props => [expense, saveAsDraft];
}
