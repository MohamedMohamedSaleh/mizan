import '../../domain/entities/expenses_summary_entity.dart';
import 'expense_model_helpers.dart';

class ExpensesSummaryModel extends ExpensesSummaryEntity {
  const ExpensesSummaryModel({
    required super.totalAmount,
    required super.expensesCount,
    required super.draftCount,
    required super.savedCount,
    required super.voidedCount,
  });

  factory ExpensesSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExpensesSummaryModel(
      totalAmount: ExpenseModelHelpers.doubleValue(json['total_amount']),
      expensesCount: _intValue(json['expenses_count']),
      draftCount: _intValue(json['draft_count']),
      savedCount: _intValue(json['saved_count']),
      voidedCount: _intValue(json['voided_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      'expenses_count': expensesCount,
      'draft_count': draftCount,
      'saved_count': savedCount,
      'voided_count': voidedCount,
    };
  }

  ExpensesSummaryEntity toEntity() => ExpensesSummaryEntity(
        totalAmount: totalAmount,
        expensesCount: expensesCount,
        draftCount: draftCount,
        savedCount: savedCount,
        voidedCount: voidedCount,
      );

  ExpensesSummaryModel copyWith({
    double? totalAmount,
    int? expensesCount,
    int? draftCount,
    int? savedCount,
    int? voidedCount,
  }) {
    return ExpensesSummaryModel(
      totalAmount: totalAmount ?? this.totalAmount,
      expensesCount: expensesCount ?? this.expensesCount,
      draftCount: draftCount ?? this.draftCount,
      savedCount: savedCount ?? this.savedCount,
      voidedCount: voidedCount ?? this.voidedCount,
    );
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? 0;
    return 0;
  }
}
