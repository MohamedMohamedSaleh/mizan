import '../../domain/entities/expense_enums.dart';

abstract final class ExpenseModelHelpers {
  static String stringValue(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  static String? nullableStringValue(Object? value) {
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  static bool boolValue(Object? value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }

  static double doubleValue(Object? value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  static DateTime? dateTimeValue(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static String? dateTimeToJson(DateTime? value) => value?.toIso8601String();

  static AccountType accountTypeValue(Object? value) {
    return _enumValue(
      value,
      AccountType.values,
      fallback: AccountType.expense,
    );
  }

  static PaymentAccountType? paymentAccountTypeValue(Object? value) {
    return _nullableEnumValue(value, PaymentAccountType.values);
  }

  static ExpenseStatus expenseStatusValue(Object? value) {
    return _enumValue(
      value,
      ExpenseStatus.values,
      fallback: ExpenseStatus.draft,
    );
  }

  static RecurrenceType? recurrenceTypeValue(Object? value) {
    return _nullableEnumValue(value, RecurrenceType.values);
  }

  static JournalSourceType journalSourceTypeValue(Object? value) {
    return _enumValue(
      value,
      JournalSourceType.values,
      fallback: JournalSourceType.manual,
    );
  }

  static JournalEntryStatus journalEntryStatusValue(Object? value) {
    return _enumValue(
      value,
      JournalEntryStatus.values,
      fallback: JournalEntryStatus.draft,
    );
  }

  static String enumToJson(Enum value) => value.name;
  static String? nullableEnumToJson(Enum? value) => value?.name;

  static T _enumValue<T extends Enum>(
    Object? value,
    List<T> values, {
    required T fallback,
  }) {
    return _nullableEnumValue(value, values) ?? fallback;
  }

  static T? _nullableEnumValue<T extends Enum>(Object? value, List<T> values) {
    if (value == null) return null;
    final normalized = value.toString().trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final item in values) {
      if (item.name == normalized) return item;
    }
    return null;
  }
}
