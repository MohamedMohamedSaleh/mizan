import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/result.dart';
import '../../domain/usecases/delete_vendor_usecase.dart';
import '../../domain/usecases/get_vendors_usecase.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../utils/vendor_status_utils.dart';
import '../view_model/vendor_filter_view_model.dart';
import '../view_model/vendor_list_item_view_model.dart';
import '../view_model/vendors_summary_view_model.dart';
import 'vendors_state.dart';

class VendorsCubit extends Cubit<VendorsState> {
  VendorsCubit({
    required GetVendorsUseCase getVendorsUseCase,
    required DeleteVendorUseCase deleteVendorUseCase,
  })  : _getVendorsUseCase = getVendorsUseCase,
        _deleteVendorUseCase = deleteVendorUseCase,
        super(const VendorsInitial());

  final GetVendorsUseCase _getVendorsUseCase;
  final DeleteVendorUseCase _deleteVendorUseCase;

  VendorFilterViewModel _filters = const VendorFilterViewModel();
  List<String> _availableStatuses = VendorStatusUtils.all;

  Future<void> loadVendors() => _load(_filters);

  Future<void> refresh() => _load(_filters);

  Future<void> search(String query) {
    _filters = _filters.copyWith(
      search: query.trim().isEmpty ? null : query.trim(),
      clearSearch: query.trim().isEmpty,
    );
    return _load(_filters);
  }

  Future<void> filterByStatus(String? status) {
    final normalized =
        status == null || status.trim().isEmpty ? null : VendorStatusUtils.normalize(status);
    _filters = _filters.copyWith(
      status: normalized,
      clearStatus: normalized == null,
    );
    return _load(_filters);
  }

  Future<void> clearFilters() {
    _filters = const VendorFilterViewModel();
    return _load(_filters);
  }

  Future<bool> deleteVendor(String id) async {
    final result = await _deleteVendorUseCase(DeleteVendorParams(id: id));
    return result.fold(
      (failure) {
        emit(VendorsError(
          message: failure.message,
          filters: _filters,
          availableStatuses: _availableStatuses,
        ));
        return false;
      },
      (_) async {
        await refresh();
        return true;
      },
    );
  }

  Future<void> _load(VendorFilterViewModel filters) async {
    emit(VendorsLoading(filters: filters, availableStatuses: _availableStatuses));

    final result = await _getVendorsUseCase(
      GetVendorsParams(
        search: filters.search,
        status: filters.status,
      ),
    );

    if (result is Error<List<VendorEntity>>) {
      emit(VendorsError(
        message: result.failure.message,
        filters: filters,
        availableStatuses: _availableStatuses,
      ));
      return;
    }

    final vendors = (result as Success<List<VendorEntity>>).data;
    _availableStatuses = _mergeStatuses(vendors, _availableStatuses);
    final items = vendors.map(VendorListItemViewModel.fromEntity).toList();
    final summary = _summaryFromVendors(vendors);

    if (items.isEmpty) {
      emit(VendorsEmpty(
        summary: summary,
        filters: filters,
        availableStatuses: _availableStatuses,
      ));
      return;
    }

    emit(VendorsLoaded(
      vendors: items,
      summary: summary,
      filters: filters,
      availableStatuses: _availableStatuses,
    ));
  }

  VendorsSummaryViewModel _summaryFromVendors(List<VendorEntity> vendors) {
    var withEmailCount = 0;
    var withPhoneCount = 0;

    for (final vendor in vendors) {
      if ((vendor.email?.trim().isNotEmpty ?? false)) {
        withEmailCount++;
      }
      if ((vendor.phone?.trim().isNotEmpty ?? false)) {
        withPhoneCount++;
      }
    }

    return VendorsSummaryViewModel(
      totalCount: vendors.length,
      withEmailCount: withEmailCount,
      withPhoneCount: withPhoneCount,
    );
  }

  List<String> _mergeStatuses(
    List<VendorEntity> vendors,
    List<String> existingStatuses,
  ) {
    final merged = <String>{...existingStatuses};
    for (final vendor in vendors) {
        final status = vendor.status?.trim();
        if (status != null && status.isNotEmpty) {
        merged.add(VendorStatusUtils.normalize(status));
      }
    }

    merged.addAll(VendorStatusUtils.all);
    final ordered = merged.toList()
      ..sort((a, b) {
        final normalizedA = VendorStatusUtils.normalize(a);
        final normalizedB = VendorStatusUtils.normalize(b);
        if (normalizedA == normalizedB) return 0;
        if (normalizedA == VendorStatusUtils.active) return -1;
        return 1;
      });
    return ordered;
  }
}
