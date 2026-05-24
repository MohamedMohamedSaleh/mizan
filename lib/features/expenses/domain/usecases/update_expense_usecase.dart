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

class UpdateExpenseUseCase
    extends UseCase<ExpenseEntity, UpdateExpenseParams> {
  UpdateExpenseUseCase({
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
  Future<Result<ExpenseEntity>> call(UpdateExpenseParams params) async {
    final validation = validateExpenseForSave(params.expense);
    if (validation is Error<void>) return Error(validation.failure);

    final existingResult = await _expensesRepository.getExpenseById(
      params.expense.id,
    );
    if (existingResult is Error<ExpenseEntity>) {
      return Error(existingResult.failure);
    }
    final existing = (existingResult as Success<ExpenseEntity>).data;

    if (existing.status == ExpenseStatus.draft || params.saveAsDraft) {
      return _expensesRepository.updateExpense(
        params.expense.copyWith(
          status: params.saveAsDraft ? ExpenseStatus.draft : params.expense.status,
          clearJournalEntryId: params.saveAsDraft,
        ),
      );
    }

    if (params.expense.status != ExpenseStatus.saved) {
      return _expensesRepository.updateExpense(params.expense);
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

    // TODO: Replace this multi-table update flow with a Postgres RPC transaction.
    if (existing.journalEntryId != null && existing.journalEntryId!.isNotEmpty) {
      final voidResult = await _journalEntriesRepository.voidJournalEntry(
        existing.journalEntryId!,
      );
      if (voidResult is Error<void>) return Error(voidResult.failure);
    }

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

    return _expensesRepository.updateExpense(
      params.expense.copyWith(
        status: ExpenseStatus.saved,
        journalEntryId: entry.id,
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

class UpdateExpenseParams extends Equatable {
  const UpdateExpenseParams({
    required this.expense,
    this.saveAsDraft = false,
  });

  final ExpenseEntity expense;
  final bool saveAsDraft;

  @override
  List<Object?> get props => [expense, saveAsDraft];
}
