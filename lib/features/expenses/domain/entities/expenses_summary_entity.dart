import 'package:equatable/equatable.dart';

class ExpensesSummaryEntity extends Equatable {
  const ExpensesSummaryEntity({
    required this.totalAmount,
    required this.expensesCount,
    required this.draftCount,
    required this.savedCount,
    required this.voidedCount,
  });

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
