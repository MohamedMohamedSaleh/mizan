import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/services/toast_service.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';
import '../cubit/add_vendor_cubit.dart';
import '../cubit/vendor_form_state.dart';
import '../utils/vendor_status_utils.dart';

class VendorForm extends StatefulWidget {
  const VendorForm({
    super.key,
    required this.state,
    required this.cubit,
    required this.title,
    required this.onCancel,
  });

  final VendorFormState state;
  final AddVendorCubit cubit;
  final String title;
  final VoidCallback onCancel;

  @override
  State<VendorForm> createState() => _VendorFormState();
}

class _VendorFormState extends State<VendorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _taxNumberController;
  late final TextEditingController _notesController;
  late final TextEditingController _phoneController;
  String _phoneCountryCode = 'SA';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _taxNumberController = TextEditingController();
    _notesController = TextEditingController();
    _phoneController = TextEditingController();
    _syncControllers(widget.state);
  }

  @override
  void didUpdateWidget(covariant VendorForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers(widget.state);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _taxNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppToast.error(context, widget.state.errorMessage!);
        widget.cubit.clearError();
      });
    }

    if (widget.state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final padding = context.responsive(
      mobile: AppSpacing.pagePaddingMobile,
      tablet: AppSpacing.pagePaddingTablet,
      desktop: AppSpacing.pagePaddingDesktop,
    );

    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Container(
            padding: AppSpacing.paddingAllLg,
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: AppRadius.borderRadiusBase,
              border: Border.all(color: context.colors.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.gapH24,
                  _buildResponsiveFields(context),
                  AppSpacing.gapH24,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.state.isSaving ? null : widget.onCancel,
                          child: Text(LocaleKeys.actionsCancel.tr()),
                        ),
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: AuthPrimaryButton(
                          label: LocaleKeys.actionsSave.tr(),
                          isLoading: widget.state.isSaving,
                          onPressed: _save,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveFields(BuildContext context) {
    final isTwoColumns = MediaQuery.of(context).size.width >= 700;

    final nameField = AuthTextField(
      controller: _nameController,
      label: LocaleKeys.fieldsName.tr(),
      prefixIcon: Icons.business_outlined,
      textInputAction: TextInputAction.next,
      onChanged: widget.cubit.nameChanged,
      validator: (_) => _validationFor(VendorFormState.fieldName),
    );

    final phoneField = AuthPhoneField(
      key: ValueKey('${widget.state.vendorId}-$_phoneCountryCode'),
      controller: _phoneController,
      label: LocaleKeys.authPhoneNumber.tr(),
      initialCountryCode: _phoneCountryCode,
      isRequired: false,
      textInputAction: TextInputAction.next,
      onChanged: widget.cubit.phoneChanged,
      validator: (_) => null,
    );

    final emailField = AuthTextField(
      controller: _emailController,
      label: LocaleKeys.authEmail.tr(),
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.cubit.emailChanged,
      validator: (_) => _validationFor(VendorFormState.fieldEmail),
    );

    final statusField = _StatusDropdownField(
      value: VendorStatusUtils.normalize(widget.state.status),
      enabled: !widget.state.isSaving,
      onChanged: (value) {
        if (value != null) {
          widget.cubit.statusChanged(value);
        }
      },
    );

    final addressField = AuthTextField(
      controller: _addressController,
      label: LocaleKeys.vendorsAddress.tr(),
      prefixIcon: Icons.location_on_outlined,
      textInputAction: TextInputAction.next,
      maxLines: 2,
      onChanged: widget.cubit.addressChanged,
    );

    final taxNumberField = AuthTextField(
      controller: _taxNumberController,
      label: LocaleKeys.vendorsTaxNumber.tr(),
      prefixIcon: Icons.confirmation_number_outlined,
      textInputAction: TextInputAction.next,
      onChanged: widget.cubit.taxNumberChanged,
    );

    final notesField = AuthTextField(
      controller: _notesController,
      label: LocaleKeys.vendorsNotes.tr(),
      prefixIcon: Icons.notes_outlined,
      maxLines: 4,
      textInputAction: TextInputAction.newline,
      onChanged: widget.cubit.notesChanged,
    );

    if (!isTwoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          nameField,
          AppSpacing.gapH16,
          phoneField,
          AppSpacing.gapH16,
          emailField,
          AppSpacing.gapH16,
          statusField,
          AppSpacing.gapH16,
          addressField,
          AppSpacing.gapH16,
          taxNumberField,
          AppSpacing.gapH16,
          notesField,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFormRow(nameField, phoneField),
        AppSpacing.gapH16,
        _buildFormRow(emailField, statusField),
        AppSpacing.gapH16,
        _buildFormRow(addressField, taxNumberField),
        AppSpacing.gapH16,
        _buildFormRow(notesField, const SizedBox()),
      ],
    );
  }

  Widget _buildFormRow(Widget first, Widget second) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        AppSpacing.gapW16,
        Expanded(child: second),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.cubit.saveVendor();
  }

  String? _validationFor(String key) {
    return widget.state.validationErrors[key]?.tr();
  }

  void _syncControllers(VendorFormState state) {
    _setController(_nameController, state.name);
    final parsedPhone = _parsePhone(state.phone);
    _phoneCountryCode = parsedPhone.countryCode;
    _setController(_phoneController, parsedPhone.localNumber);
    _setController(_emailController, state.email);
    _setController(_addressController, state.address);
    _setController(_taxNumberController, state.taxNumber);
    _setController(_notesController, state.notes);
  }

  void _setController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  _ParsedPhone _parsePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('+20')) {
      return _ParsedPhone(
        countryCode: 'EG',
        localNumber: trimmed.substring(3),
      );
    }
    if (trimmed.startsWith('+966')) {
      return _ParsedPhone(
        countryCode: 'SA',
        localNumber: trimmed.substring(4),
      );
    }
    return _ParsedPhone(countryCode: 'SA', localNumber: trimmed);
  }
}

class _ParsedPhone {
  const _ParsedPhone({
    required this.countryCode,
    required this.localNumber,
  });

  final String countryCode;
  final String localNumber;
}

class _StatusDropdownField extends StatelessWidget {
  const _StatusDropdownField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.fieldsStatus.tr(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
        ),
        AppSpacing.gapH8,
        DropdownButtonFormField<String>(
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(),
          items: VendorStatusUtils.all
              .map(
                (status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(VendorStatusUtils.label(status)),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
