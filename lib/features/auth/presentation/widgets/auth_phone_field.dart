import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthPhoneField extends StatefulWidget {
  const AuthPhoneField({
    super.key,
    required this.controller,
    required this.label,
    this.initialCountryCode = 'SA',
    this.onCountryChanged,
    required this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String initialCountryCode;
  final void Function(CountryCode)? onCountryChanged;
  final void Function(String completePhoneNumber)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<AuthPhoneField> createState() => _AuthPhoneFieldState();
}

class _AuthPhoneFieldState extends State<AuthPhoneField> {
  late String _selectedDialCode;
  late String _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;
    _selectedDialCode = _getDialCodeForCountry(_selectedCountryCode);
  }

  String _getDialCodeForCountry(String code) {
    switch (code.toUpperCase()) {
      case 'EG':
        return '+20';
      case 'SA':
      default:
        return '+966';
    }
  }

  void _triggerOnChanged() {
    if (widget.onChanged != null) {
      final text = widget.controller.text.trim();
      widget.onChanged!('$_selectedDialCode$text');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colors.textPrimary,
          ),
        ),
        AppSpacing.gapH8,
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          textInputAction: widget.textInputAction,
          autofillHints: const [AutofillHints.telephoneNumber],
          style: theme.textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
          decoration: InputDecoration(
            hintText: LocaleKeys.authSelectCountry.tr(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 10,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            prefixIcon: CountryCodePicker(
              builder: (country) {
                if (country == null) return const SizedBox();
                return Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12, end: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (country.flagUri != null)
                        Image.asset(
                          country.flagUri!,
                          package: 'country_code_picker',
                          width: 22,
                        ),
                      const SizedBox(width: 6),
                      Text(
                        country.dialCode ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
              topBarPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              margin: const EdgeInsets.all(0),
              initialSelection: _selectedCountryCode,
              favorite: const ['+20', 'EG', '+966', 'SA'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              showDropDownButton: true,
              pickerStyle: PickerStyle.bottomSheet,
              alignLeft: false,
              padding: const EdgeInsets.all(0),
              dialogBackgroundColor: colors.card,
              barrierColor: Colors.black38,
              dialogSize: Size(
                MediaQuery.sizeOf(context).width,
                MediaQuery.sizeOf(context).height * 0.6,
              ),
              boxDecoration: BoxDecoration(
                color: colors.card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
              dialogTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
              searchStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
              headerTextStyle:
                  theme.textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ) ??
                  TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
              closeIcon: Icon(Icons.close, color: colors.textSecondary),
              dialogItemPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              searchPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              searchDecoration: InputDecoration(
                hintText: LocaleKeys.authSelectCountry.tr(),
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary, width: 1.4),
                ),
              ),
              onChanged: (country) {
                setState(() {
                  _selectedDialCode = country.dialCode ?? '+966';
                  _selectedCountryCode = country.code ?? 'SA';
                });
                _triggerOnChanged();
                if (widget.onCountryChanged != null) {
                  widget.onCountryChanged!(country);
                }
              },
            ),
          ),
          validator: (value) {
            final phone = value?.trim() ?? '';
            if (phone.isEmpty) {
              return LocaleKeys.authPhoneNumberRequired.tr();
            }
            final country = _selectedCountryCode.toUpperCase();
            if (country == 'SA' && phone.length != 9) {
              return LocaleKeys.authSaudiPhoneLengthError.tr();
            }
            if (country == 'EG' && phone.length != 10) {
              return LocaleKeys.authEgyptPhoneLengthError.tr();
            }
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (phone.length < 8) {
              return LocaleKeys.authInvalidPhoneNumber.tr();
            }
            return null;
          },
          onChanged: (value) => _triggerOnChanged(),
        ),
      ],
    );
  }
}
