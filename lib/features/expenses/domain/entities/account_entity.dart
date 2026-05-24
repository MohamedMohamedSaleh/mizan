import 'package:equatable/equatable.dart';

import 'expense_enums.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.id,
    required this.userId,
    required this.code,
    required this.name,
    required this.type,
    this.isPaymentAccount = false,
    this.paymentAccountType,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String code;
  final String name;
  final AccountType type;
  final bool isPaymentAccount;
  final PaymentAccountType? paymentAccountType;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  AccountEntity copyWith({
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
    return AccountEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        code,
        name,
        type,
        isPaymentAccount,
        paymentAccountType,
        isActive,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
