import 'package:equatable/equatable.dart';

class VendorFilterViewModel extends Equatable {
  const VendorFilterViewModel({
    this.search,
    this.status,
  });

  final String? search;
  final String? status;

  bool get hasActiveFilters =>
      (search?.trim().isNotEmpty ?? false) ||
      (status?.trim().isNotEmpty ?? false);

  VendorFilterViewModel copyWith({
    String? search,
    bool clearSearch = false,
    String? status,
    bool clearStatus = false,
  }) {
    return VendorFilterViewModel(
      search: clearSearch ? null : search ?? this.search,
      status: clearStatus ? null : status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [search, status];
}
