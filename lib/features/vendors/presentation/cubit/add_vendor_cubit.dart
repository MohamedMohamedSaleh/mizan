import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../domain/usecases/create_vendor_usecase.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../utils/vendor_status_utils.dart';
import 'vendor_form_state.dart';

class AddVendorCubit extends Cubit<VendorFormState> {
  AddVendorCubit({
    required CreateVendorUseCase createVendorUseCase,
  })  : _createVendorUseCase = createVendorUseCase,
        super(const VendorFormState());

  final CreateVendorUseCase _createVendorUseCase;

  void nameChanged(String value) => _emitFieldUpdate(name: value, clearSave: true);
  void phoneChanged(String value) => _emitFieldUpdate(phone: value, clearSave: true);
  void emailChanged(String value) => _emitFieldUpdate(email: value, clearSave: true);
  void addressChanged(String value) =>
      _emitFieldUpdate(address: value, clearSave: true);
  void taxNumberChanged(String value) =>
      _emitFieldUpdate(taxNumber: value, clearSave: true);
  void notesChanged(String value) => _emitFieldUpdate(notes: value, clearSave: true);
  void statusChanged(String value) => _emitFieldUpdate(
        status: VendorStatusUtils.normalize(value),
        clearSave: true,
      );

  Future<void> saveVendor() async {
    final errors = validateForm();
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        saveSuccess: false,
        validationErrors: const {},
        clearErrorMessage: true,
      ),
    );

    final result = await _createVendorUseCase(
      CreateVendorParams(vendor: buildVendorEntity()),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
          saveSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          saveSuccess: true,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Map<String, String> validateForm() {
    final errors = <String, String>{};
    if (state.name.trim().isEmpty) {
      errors[VendorFormState.fieldName] = LocaleKeys.vendorsValidationNameRequired;
    }
    final email = state.email.trim();
    if (email.isNotEmpty && !_isValidEmail(email)) {
      errors[VendorFormState.fieldEmail] = LocaleKeys.messagesInvalidEmail;
    }
    return errors;
  }

  VendorEntity buildVendorEntity() {
    return VendorEntity(
      id: state.vendorId,
      userId: '',
      name: state.name.trim(),
      phone: _nullable(state.phone),
      email: _nullable(state.email),
      address: _nullable(state.address),
      taxNumber: _nullable(state.taxNumber),
      notes: _nullable(state.notes),
      status: VendorStatusUtils.normalize(state.status),
    );
  }

  void hydrateFromVendor(VendorEntity vendor) {
    emit(
      state.copyWith(
        vendorId: vendor.id,
        name: vendor.name,
        phone: vendor.phone ?? '',
        email: vendor.email ?? '',
        address: vendor.address ?? '',
        taxNumber: vendor.taxNumber ?? '',
        notes: vendor.notes ?? '',
        status: VendorStatusUtils.normalize(vendor.status),
        isInitialLoading: false,
        saveSuccess: false,
        validationErrors: const {},
        clearErrorMessage: true,
      ),
    );
  }

  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void _emitFieldUpdate({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? taxNumber,
    String? notes,
    String? status,
    bool clearSave = false,
  }) {
    emit(
      state.copyWith(
        name: name,
        phone: phone,
        email: email,
        address: address,
        taxNumber: taxNumber,
        notes: notes,
        status: status,
        saveSuccess: clearSave ? false : state.saveSuccess,
        clearErrorMessage: true,
      ),
    );
  }

  String? _nullable(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(value);
  }
}
