import 'package:equatable/equatable.dart';

import '../view_model/vendor_filter_view_model.dart';
import '../view_model/vendor_list_item_view_model.dart';
import '../view_model/vendors_summary_view_model.dart';

sealed class VendorsState extends Equatable {
  const VendorsState();

  @override
  List<Object?> get props => [];
}

class VendorsInitial extends VendorsState {
  const VendorsInitial();
}

class VendorsLoading extends VendorsState {
  const VendorsLoading({
    required this.filters,
    required this.availableStatuses,
  });

  final VendorFilterViewModel filters;
  final List<String> availableStatuses;

  @override
  List<Object?> get props => [filters, availableStatuses];
}

class VendorsLoaded extends VendorsState {
  const VendorsLoaded({
    required this.vendors,
    required this.summary,
    required this.filters,
    required this.availableStatuses,
  });

  final List<VendorListItemViewModel> vendors;
  final VendorsSummaryViewModel summary;
  final VendorFilterViewModel filters;
  final List<String> availableStatuses;

  @override
  List<Object?> get props => [vendors, summary, filters, availableStatuses];
}

class VendorsEmpty extends VendorsState {
  const VendorsEmpty({
    required this.summary,
    required this.filters,
    required this.availableStatuses,
  });

  final VendorsSummaryViewModel summary;
  final VendorFilterViewModel filters;
  final List<String> availableStatuses;

  @override
  List<Object?> get props => [summary, filters, availableStatuses];
}

class VendorsError extends VendorsState {
  const VendorsError({
    required this.message,
    required this.filters,
    required this.availableStatuses,
  });

  final String message;
  final VendorFilterViewModel filters;
  final List<String> availableStatuses;

  @override
  List<Object?> get props => [message, filters, availableStatuses];
}
