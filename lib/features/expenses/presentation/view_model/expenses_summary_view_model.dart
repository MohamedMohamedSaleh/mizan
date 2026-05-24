import 'package:equatable/equatable.dart';

import '../../domain/entities/expenses_summary_entity.dart';

class ExpensesSummaryViewModel extends Equatable {
  const ExpensesSummaryViewModel({
    required this.totalAmount,
    required this.expensesCount,
    required this.draftCount,
    required this.savedCount,
    required this.voidedCount,
  });

  factory ExpensesSummaryViewModel.fromEntity(ExpensesSummaryEntity entity) {
    return ExpensesSummaryViewModel(
      totalAmount: entity.totalAmount,
      expensesCount: entity.expensesCount,
      draftCount: entity.draftCount,
      savedCount: entity.savedCount,
      voidedCount: entity.voidedCount,
    );
  }

  static const empty = ExpensesSummaryViewModel(
    totalAmount: 0,
    expensesCount: 0,
    draftCount: 0,
    savedCount: 0,
    voidedCount: 0,
  );

  final double totalAmount;
  final int expensesCount;
  final int draftCount;
  final int savedCount;
  final int voidedCount;

  @override
  List<Object?> get props => [
        totalAmount,
        expensesCount,
        draftCount,
        savedCount,
        voidedCount,
      ];
}
