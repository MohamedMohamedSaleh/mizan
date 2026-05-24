import '../../domain/entities/account_entity.dart';
import '../../domain/entities/expense_enums.dart';
import 'expense_model_helpers.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    required super.userId,
    required super.code,
    required super.name,
    required super.type,
    super.isPaymentAccount,
    super.paymentAccountType,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      code: ExpenseModelHelpers.stringValue(json['code']),
      name: ExpenseModelHelpers.stringValue(json['name']),
      type: ExpenseModelHelpers.accountTypeValue(json['type']),
      isPaymentAccount: ExpenseModelHelpers.boolValue(
        json['is_payment_account'],
      ),
      paymentAccountType: ExpenseModelHelpers.paymentAccountTypeValue(
        json['payment_account_type'],
      ),
      isActive: ExpenseModelHelpers.boolValue(json['is_active'], fallback: true),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
      updatedAt: ExpenseModelHelpers.dateTimeValue(json['updated_at']),
      deletedAt: ExpenseModelHelpers.dateTimeValue(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'name': name,
      'type': ExpenseModelHelpers.enumToJson(type),
      'is_payment_account': isPaymentAccount,
      'payment_account_type': ExpenseModelHelpers.nullableEnumToJson(
        paymentAccountType,
      ),
      'is_active': isActive,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  AccountEntity toEntity() => AccountEntity(
        id: id,
        userId: userId,
        code: code,
        name: name,
        type: type,
        isPaymentAccount: isPaymentAccount,
        paymentAccountType: paymentAccountType,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  AccountModel copyWith({
    String? id,
    String? userId,
    String? code,
    String? name,
    AccountType? type,
    bool? isPaymentAccount,
    PaymentAccountType? paymentAccountType,
    bool clearPaymentAccountType = false,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return AccountModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      isPaymentAccount: isPaymentAccount ?? this.isPaymentAccount,
      paymentAccountType: clearPaymentAccountType
          ? null
          : paymentAccountType ?? this.paymentAccountType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
