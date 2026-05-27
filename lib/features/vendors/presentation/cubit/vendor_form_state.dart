import 'package:equatable/equatable.dart';

class VendorFormState extends Equatable {
  const VendorFormState({
    this.vendorId = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.taxNumber = '',
    this.notes = '',
    this.status = '',
    this.isInitialLoading = false,
    this.isSaving = false,
    this.saveSuccess = false,
    this.validationErrors = const {},
    this.errorMessage,
  });

  final String vendorId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String taxNumber;
  final String notes;
  final String status;
  final bool isInitialLoading;
  final bool isSaving;
  final bool saveSuccess;
  final Map<String, String> validationErrors;
  final String? errorMessage;

  VendorFormState copyWith({
    String? vendorId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? taxNumber,
    String? notes,
    String? status,
    bool? isInitialLoading,
    bool? isSaving,
    bool? saveSuccess,
    Map<String, String>? validationErrors,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return VendorFormState(
      vendorId: vendorId ?? this.vendorId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      taxNumber: taxNumber ?? this.taxNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      validationErrors: validationErrors ?? this.validationErrors,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  static const fieldName = 'name';
  static const fieldEmail = 'email';

  @override
  List<Object?> get props => [
        vendorId,
        name,
        phone,
        email,
        address,
        taxNumber,
        notes,
        status,
        isInitialLoading,
        isSaving,
        saveSuccess,
        validationErrors,
        errorMessage,
      ];
}
