import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/expense_category_entity.dart';
import '../entities/expense_entity.dart';
import '../entities/expense_enums.dart';
import '../entities/journal_entry_entity.dart';
import '../entities/journal_entry_line_entity.dart';

class ExpenseJournalBundle {
  const ExpenseJournalBundle({
    required this.entry,
    required this.lines,
  });

  final JournalEntryEntity entry;
  final List<JournalEntryLineEntity> lines;
}

Result<ExpenseJournalBundle> buildExpenseJournalBundle({
  required ExpenseEntity expense,
  required ExpenseCategoryEntity category,
}) {
  final expenseAccountId = category.expenseAccountId;
  final paidFromAccountId = expense.paidFromAccountId;
  final expenseDate = expense.expenseDate;

  if (expenseAccountId == null || expenseAccountId.isEmpty) {
    return const Error(
      UnexpectedFailure(message: 'Selected category has no expense account.'),
    );
  }
  if (paidFromAccountId == null || paidFromAccountId.isEmpty) {
    return const Error(
      UnexpectedFailure(message: 'Paid from account is required.'),
    );
  }
  if (expenseDate == null) {
    return const Error(
      UnexpectedFailure(message: 'Expense date is required.'),
    );
  }

  final entry = JournalEntryEntity(
    id: '',
    userId: expense.userId,
    number: 'EXP-${expense.code}',
    entryDate: expenseDate,
    currency: expense.currency,
    description: expense.description,
    sourceType: JournalSourceType.expense,
    sourceId: expense.id.isEmpty ? null : expense.id,
    status: JournalEntryStatus.posted,
  );

  final lines = [
    JournalEntryLineEntity(
      id: '',
      userId: expense.userId,
      journalEntryId: '',
      accountId: expenseAccountId,
      description: expense.description,
      debit: expense.amount,
    ),
    JournalEntryLineEntity(
      id: '',
      userId: expense.userId,
      journalEntryId: '',
      accountId: paidFromAccountId,
      description: expense.description,
      credit: expense.amount,
    ),
  ];

  final validation = validateJournalLines(lines);
  if (validation is Error<void>) {
    return Error(validation.failure);
  }

  return Success(ExpenseJournalBundle(entry: entry, lines: lines));
}

Result<void> validateJournalLines(List<JournalEntryLineEntity> lines) {
  var debitTotal = 0.0;
  var creditTotal = 0.0;

  for (final line in lines) {
    final hasDebit = line.debit > 0;
    final hasCredit = line.credit > 0;
    if (hasDebit && hasCredit) {
      return const Error(
        UnexpectedFailure(
          message: 'Journal line cannot have debit and credit together.',
        ),
      );
    }
    if (!hasDebit && !hasCredit) {
      return const Error(
        UnexpectedFailure(message: 'Journal line amount cannot be zero.'),
      );
    }
    debitTotal += line.debit;
    creditTotal += line.credit;
  }

  if ((debitTotal - creditTotal).abs() > 0.0001) {
    return const Error(
      UnexpectedFailure(message: 'Saved expense must have balanced journal entry.'),
    );
  }

  return const Success(null);
}

Result<void> validateExpenseForSave(ExpenseEntity expense) {
  if (expense.amount <= 0) {
    return const Error(
      UnexpectedFailure(message: 'Expense amount must be greater than zero.'),
    );
  }
  if (expense.expenseDate == null) {
    return const Error(
      UnexpectedFailure(message: 'Expense date is required.'),
    );
  }
  if (expense.categoryId == null || expense.categoryId!.isEmpty) {
    return const Error(
      UnexpectedFailure(message: 'Expense category is required.'),
    );
  }
  if (expense.paidFromAccountId == null || expense.paidFromAccountId!.isEmpty) {
    return const Error(
      UnexpectedFailure(message: 'Paid from account is required.'),
    );
  }
  return const Success(null);
}
