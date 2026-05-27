import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/vendors_cubit.dart';
import '../cubit/vendors_state.dart';
import '../view_model/vendor_filter_view_model.dart';
import '../view_model/vendor_list_item_view_model.dart';
import '../view_model/vendors_summary_view_model.dart';
import '../widgets/vendor_status_badge.dart';
import '../widgets/vendors_summary_card.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  List<VendorListItemViewModel> _cachedVendors = const [];
  VendorFilterViewModel _cachedFilters = const VendorFilterViewModel();
  List<String> _cachedStatuses = const [];

  @override
  void initState() {
    super.initState();
    context.read<VendorsCubit>().loadVendors();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VendorsCubit, VendorsState>(
      listener: (context, state) {
        if (state is VendorsError) {
          AppToast.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBar(title: Text(LocaleKeys.vendorsTitle.tr()))
            : null,
        floatingActionButton: context.isMobile
            ? FloatingActionButton(
                onPressed: () => _openAddVendor(context),
                child: const Icon(Icons.add),
              )
            : null,
        body: BlocBuilder<VendorsCubit, VendorsState>(
          builder: (context, state) {
            if (state is VendorsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is VendorsLoading) {
              if (_cachedStatuses.isEmpty && _cachedVendors.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return _VendorsBody(
                vendors: _cachedVendors,
                filters: _cachedFilters,
                availableStatuses: _cachedStatuses,
                summary: _summaryForCachedVendors(),
                isSectionLoading: true,
              );
            }
            if (state is VendorsLoaded) {
              _cachedVendors = state.vendors;
              _cachedFilters = state.filters;
              _cachedStatuses = state.availableStatuses;
              return _VendorsBody(
                vendors: state.vendors,
                filters: state.filters,
                availableStatuses: state.availableStatuses,
                summary: state.summary,
              );
            }
            if (state is VendorsEmpty) {
              _cachedVendors = const [];
              _cachedFilters = state.filters;
              _cachedStatuses = state.availableStatuses;
              return _VendorsBody(
                vendors: const [],
                filters: state.filters,
                availableStatuses: state.availableStatuses,
                summary: state.summary,
              );
            }
            return Center(child: Text(LocaleKeys.messagesError.tr()));
          },
        ),
      ),
    );
  }

  VendorsSummaryViewModel _summaryForCachedVendors() {
    var withEmailCount = 0;
    var withPhoneCount = 0;

    for (final vendor in _cachedVendors) {
      if ((vendor.email?.trim().isNotEmpty ?? false)) {
        withEmailCount++;
      }
      if ((vendor.phone?.trim().isNotEmpty ?? false)) {
        withPhoneCount++;
      }
    }

    return VendorsSummaryViewModel(
      totalCount: _cachedVendors.length,
      withEmailCount: withEmailCount,
      withPhoneCount: withPhoneCount,
    );
  }
}

class _VendorsBody extends StatelessWidget {
  const _VendorsBody({
    required this.vendors,
    required this.filters,
    required this.availableStatuses,
    required this.summary,
    this.isSectionLoading = false,
  });

  final List<VendorListItemViewModel> vendors;
  final VendorFilterViewModel filters;
  final List<String> availableStatuses;
  final VendorsSummaryViewModel summary;
  final bool isSectionLoading;

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive(
      mobile: AppSpacing.pagePaddingMobile,
      tablet: AppSpacing.pagePaddingTablet,
      desktop: AppSpacing.pagePaddingDesktop,
    );

    return RefreshIndicator(
      onRefresh: context.read<VendorsCubit>().refresh,
      child: ListView(
        padding: padding,
        children: [
          if (!context.isMobile) const _Header(),
          AppSpacing.gapH32,
          _SummaryStrip(summary: summary),
          AppSpacing.gapH24,
          if (context.isMobile)
            _MobileSearch(
              filters: filters,
              availableStatuses: availableStatuses,
            )
          else
            _FilterPanel(
              filters: filters,
              availableStatuses: availableStatuses,
            ),
          AppSpacing.gapH16,
          if (isSectionLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          if (vendors.isEmpty)
            const _EmptyState()
          else if (context.isMobile)
            ...vendors.map((vendor) => _VendorCard(vendor: vendor))
          else
            _VendorsTable(vendors: vendors),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.vendorsTitle.tr(),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddVendor(context),
          icon: const Icon(Icons.add),
          label: Text(LocaleKeys.vendorsAdd.tr()),
        ),
      ],
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.summary});

  final VendorsSummaryViewModel summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      VendorsSummaryCard(
        title: LocaleKeys.vendorsSummaryTotal.tr(),
        value: summary.totalCount.toString(),
        icon: Icons.store_outlined,
      ),
      VendorsSummaryCard(
        title: LocaleKeys.vendorsSummaryWithEmail.tr(),
        value: summary.withEmailCount.toString(),
        icon: Icons.email_outlined,
      ),
      VendorsSummaryCard(
        title: LocaleKeys.vendorsSummaryWithPhone.tr(),
        value: summary.withPhoneCount.toString(),
        icon: Icons.phone_outlined,
        endPadding: 0,
      ),
    ];

    if (context.isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: cards),
      );
    }

    return Row(children: cards.map((card) => Expanded(child: card)).toList());
  }
}

class _MobileSearch extends StatelessWidget {
  const _MobileSearch({
    required this.filters,
    required this.availableStatuses,
  });

  final VendorFilterViewModel filters;
  final List<String> availableStatuses;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SearchField(filters: filters)),
        AppSpacing.gapW8,
        IconButton.filledTonal(
          onPressed: () {
            final cubit = context.read<VendorsCubit>();
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: _MobileFilterSheet(
                  initialFilters: filters,
                  availableStatuses: availableStatuses,
                ),
              ),
            );
          },
          icon: const Icon(Icons.filter_list),
          tooltip: LocaleKeys.expensesFilters.tr(),
        ),
      ],
    );
  }
}

class _MobileFilterSheet extends StatefulWidget {
  const _MobileFilterSheet({
    required this.initialFilters,
    required this.availableStatuses,
  });

  final VendorFilterViewModel initialFilters;
  final List<String> availableStatuses;

  @override
  State<_MobileFilterSheet> createState() => _MobileFilterSheetState();
}

class _MobileFilterSheetState extends State<_MobileFilterSheet> {
  late String? _status;

  bool get _hasActiveFilters => _status != null && _status!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _status = widget.initialFilters.status;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterPanel(
              filters: widget.initialFilters.copyWith(
                status: _status,
                clearStatus: _status == null || _status!.isEmpty,
              ),
              availableStatuses: widget.availableStatuses,
              showSearchField: false,
              onStatusChanged: (value) => setState(() => _status = value),
              onClearFilters: _hasActiveFilters
                  ? () => setState(() => _status = null)
                  : null,
            ),
            AppSpacing.gapH12,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<VendorsCubit>().filterByStatus(_status);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
                label: Text(LocaleKeys.actionsConfirm.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.filters,
    required this.availableStatuses,
    this.showSearchField = true,
    this.onStatusChanged,
    this.onClearFilters,
  });

  final VendorFilterViewModel filters;
  final List<String> availableStatuses;
  final bool showSearchField;
  final ValueChanged<String?>? onStatusChanged;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (showSearchField)
            SizedBox(width: 280, child: _SearchField(filters: filters)),
          SizedBox(
            width: 220,
            child: _StatusFilter(
              filters: filters,
              availableStatuses: availableStatuses,
              onChanged: onStatusChanged,
            ),
          ),
          OutlinedButton.icon(
            onPressed: onClearFilters ??
                (filters.hasActiveFilters
                    ? context.read<VendorsCubit>().clearFilters
                    : null),
            icon: const Icon(Icons.clear),
            label: Text(LocaleKeys.expensesClearFilters.tr()),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.filters});

  final VendorFilterViewModel filters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: filters.search,
      decoration: InputDecoration(
        hintText: LocaleKeys.vendorsSearchHint.tr(),
        prefixIcon: const Icon(Icons.search),
      ),
      onFieldSubmitted: context.read<VendorsCubit>().search,
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.filters,
    required this.availableStatuses,
    this.onChanged,
  });

  final VendorFilterViewModel filters;
  final List<String> availableStatuses;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey(filters.status),
      initialValue: filters.status,
      isExpanded: true,
      decoration: InputDecoration(labelText: LocaleKeys.vendorsStatusFilter.tr()),
      items: availableStatuses
          .map(
            (status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            ),
          )
          .toList(),
      onChanged: onChanged ?? context.read<VendorsCubit>().filterByStatus,
    );
  }
}

class _VendorsTable extends StatelessWidget {
  const _VendorsTable({required this.vendors});

  final List<VendorListItemViewModel> vendors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(LocaleKeys.fieldsName.tr())),
            DataColumn(label: Text(LocaleKeys.authPhoneNumber.tr())),
            DataColumn(label: Text(LocaleKeys.authEmail.tr())),
            DataColumn(label: Text(LocaleKeys.fieldsStatus.tr())),
            DataColumn(label: Text(LocaleKeys.fieldsDate.tr())),
            DataColumn(label: Text(LocaleKeys.actionsEdit.tr())),
          ],
          rows: vendors
              .map(
                (vendor) => DataRow(
                  cells: [
                    DataCell(Text(vendor.name)),
                    DataCell(Text(vendor.phone ?? '-')),
                    DataCell(Text(vendor.email ?? '-')),
                    DataCell(VendorStatusBadge(status: vendor.status)),
                    DataCell(Text(_formatDate(vendor.updatedAt))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _openEditVendor(context, vendor.id),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(context, vendor.id),
                            icon: const Icon(Icons.delete_outline),
                            color: context.colors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  const _VendorCard({required this.vendor});

  final VendorListItemViewModel vendor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: AppRadius.borderRadiusBase,
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    vendor.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                VendorStatusBadge(status: vendor.status),
              ],
            ),
            AppSpacing.gapH12,
            Text(vendor.phone ?? '-'),
            AppSpacing.gapH4,
            Text(vendor.email ?? '-'),
            if ((vendor.address?.trim().isNotEmpty ?? false)) ...[
              AppSpacing.gapH8,
              Text(
                vendor.address!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
            AppSpacing.gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(vendor.updatedAt)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _openEditVendor(context, vendor.id),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () => _confirmDelete(context, vendor.id),
                      icon: const Icon(Icons.delete_outline),
                      color: context.colors.error,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllXl,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.store_outlined,
            size: 48,
            color: context.colors.textSecondary,
          ),
          AppSpacing.gapH12,
          Text(LocaleKeys.vendorsNoVendors.tr()),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? date) =>
    date == null ? '-' : DateFormat.yMMMd().format(date);

Future<void> _confirmDelete(BuildContext context, String id) async {
  final vendorsCubit = context.read<VendorsCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(LocaleKeys.vendorsDelete.tr()),
      content: Text(LocaleKeys.vendorsConfirmDelete.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(LocaleKeys.actionsCancel.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(LocaleKeys.actionsConfirm.tr()),
        ),
      ],
    ),
  );

  if (confirmed ?? false) {
    final deleted = await vendorsCubit.deleteVendor(id);
    if (deleted && context.mounted) {
      AppToast.success(context, LocaleKeys.vendorsDeletedSuccessfully.tr());
    }
  }
}

Future<void> _openAddVendor(BuildContext context) async {
  final shouldRefresh = await context.push<bool>(RoutePaths.addVendor);
  if (shouldRefresh == true && context.mounted) {
    await context.read<VendorsCubit>().refresh();
  }
}

Future<void> _openEditVendor(BuildContext context, String vendorId) async {
  final shouldRefresh = await context.push<bool>('/vendors/$vendorId/edit');
  if (shouldRefresh == true && context.mounted) {
    await context.read<VendorsCubit>().refresh();
  }
}
