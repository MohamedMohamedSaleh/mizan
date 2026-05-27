import '../../domain/usecases/get_vendor_by_id_usecase.dart';
import '../../domain/usecases/update_vendor_usecase.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import 'add_vendor_cubit.dart';

class EditVendorCubit extends AddVendorCubit {
  EditVendorCubit({
    required super.createVendorUseCase,
    required GetVendorByIdUseCase getVendorByIdUseCase,
    required UpdateVendorUseCase updateVendorUseCase,
  })  : _getVendorByIdUseCase = getVendorByIdUseCase,
        _updateVendorUseCase = updateVendorUseCase;

  final GetVendorByIdUseCase _getVendorByIdUseCase;
  final UpdateVendorUseCase _updateVendorUseCase;

  Future<void> loadVendor(String id) async {
    emit(
      state.copyWith(
        isInitialLoading: true,
        saveSuccess: false,
        clearErrorMessage: true,
      ),
    );

    final result = await _getVendorByIdUseCase(GetVendorByIdParams(id: id));
    result.fold(
      (failure) => emit(
        state.copyWith(
          isInitialLoading: false,
          errorMessage: failure.message,
        ),
      ),
      hydrateFromVendor,
    );
  }

  @override
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

    final result = await _updateVendorUseCase(
      UpdateVendorParams(vendor: _buildUpdatedVendor()),
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

  VendorEntity _buildUpdatedVendor() {
    final vendor = buildVendorEntity();
    return vendor.copyWith(id: state.vendorId);
  }
}
