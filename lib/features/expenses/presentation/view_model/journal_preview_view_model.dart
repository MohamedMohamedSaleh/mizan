import 'package:equatable/equatable.dart';

class JournalPreviewLineViewModel extends Equatable {
  const JournalPreviewLineViewModel({
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  final String accountId;
  final String accountName;
  final double debit;
  final double credit;

  @override
  List<Object?> get props => [accountId, accountName, debit, credit];
}

class JournalPreviewViewModel extends Equatable {
  const JournalPreviewViewModel({
    required this.lines,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });

  static const empty = JournalPreviewViewModel(
    lines: [],
    totalDebit: 0,
    totalCredit: 0,
    isBalanced: false,
  );

  final List<JournalPreviewLineViewModel> lines;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;

  @override
  List<Object?> get props => [lines, totalDebit, totalCredit, isBalanced];
}
