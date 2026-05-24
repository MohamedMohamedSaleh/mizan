import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/expense_entity.dart';
import '../entities/expense_enums.dart';
import '../repositories/expenses_repository.dart';
import '../repositories/journal_entries_repository.dart';

class DeleteExpenseUseCase extends UseCase<void, DeleteExpenseParams> {
  DeleteExpenseUseCase({
    required ExpensesRepository expensesRepository,
    required JournalEntriesRepository journalEntriesRepository,
  })  : _expensesRepository = expensesRepository,
        _journalEntriesRepository = journalEntriesRepository;

  final ExpensesRepository _expensesRepository;
  final JournalEntriesRepository _journalEntriesRepository;

  @override
  Future<Result<void>> call(DeleteExpenseParams params) async {
    final expenseResult = await _expensesRepository.getExpenseById(params.id);
    return expenseResult.fold(
      Error.new,
      (expense) async {
        if (expense.status == ExpenseStatus.saved) {
          final journalEntryId = expense.journalEntryId;
          if (journalEntryId != null && journalEntryId.isNotEmpty) {
            final voidResult = await _journalEntriesRepository.voidJournalEntry(
              journalEntryId,
            );
            if (voidResult is Error<void>) return Error(voidResult.failure);
          }
          final now = DateTime.now();
          final updateResult = await _expensesRepository.updateExpense(
            expense.copyWith(
              status: ExpenseStatus.voided,
              deletedAt: now,
            ),
          );
          if (updateResult is Error<ExpenseEntity>) {
            return Error(updateResult.failure);
          }
          return const Success(null);
        }

        return _expensesRepository.softDeleteExpense(params.id);
      },
    );
  }
}

class DeleteExpenseParams extends Equatable {
  const DeleteExpenseParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
