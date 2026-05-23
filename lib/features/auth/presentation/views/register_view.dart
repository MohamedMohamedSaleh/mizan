import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      context.showSnackBar(LocaleKeys.authAcceptTermsRequired.tr());
      return;
    }

    context.read<AuthCubit>().register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          companyName: _companyNameController.text.trim(),
          jobTitle: _jobTitleController.text.trim(),
          country: _countryController.text.trim(),
          city: _cityController.text.trim(),
        );
  }

  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return LocaleKeys.messagesRequiredField.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            context.showSnackBar(state.message);
          } else if (state is RegisterSuccess) {
            context.showSnackBar(LocaleKeys.authRegisterSuccess.tr());
            context.go(RoutePaths.dashboard);
          } else if (state is EmailConfirmationRequired) {
            context.showSnackBar(LocaleKeys.authEmailConfirmationRequired.tr());
            context.replace(RoutePaths.login);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingVLg,
              child: AuthFormCard(
                maxWidthTablet: 900,
                maxWidthDesktop: 980,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),
                      AppSpacing.gapH32,
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isTwoColumns = MediaQuery.of(context).size.width >= 700;
                          return _buildResponsiveFields(
                            context: context,
                            isTwoColumns: isTwoColumns,
                          );
                        },
                      ),
                      AppSpacing.gapH12,
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() => _acceptedTerms = value ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(LocaleKeys.authAcceptTerms.tr()),
                      ),
                      AppSpacing.gapH12,
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return AuthPrimaryButton(
                            label: LocaleKeys.authRegister.tr(),
                            isLoading: state is AuthLoading,
                            onPressed: _onRegister,
                          );
                        },
                      ),
                      AppSpacing.gapH16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.authHaveAccount.tr(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                          ),
                          TextButton(
                            onPressed: () => context.replace(RoutePaths.login),
                            child: Text(LocaleKeys.authLogin.tr()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.account_balance_outlined,
          size: 48,
          color: context.colors.primary,
        ),
        AppSpacing.gapH12,
        Text(
          LocaleKeys.appName.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        AppSpacing.gapH4,
        Text(
          LocaleKeys.authRegister.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildResponsiveFields({
    required BuildContext context,
    required bool isTwoColumns,
  }) {
    final fullNameField = AuthTextField(
      controller: _fullNameController,
      label: LocaleKeys.authFullName.tr(),
      prefixIcon: Icons.person_outline,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      validator: _requiredValidator,
    );

    final emailField = AuthTextField(
      controller: _emailController,
      label: LocaleKeys.authEmail.tr(),
      hint: 'email@example.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return LocaleKeys.messagesRequiredField.tr();
        }
        final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
        if (!emailRegex.hasMatch(v.trim())) {
          return LocaleKeys.messagesInvalidEmail.tr();
        }
        return null;
      },
    );

    final passwordField = AuthTextField(
      controller: _passwordController,
      label: LocaleKeys.authPassword.tr(),
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.newPassword],
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: context.colors.textSecondary,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return LocaleKeys.messagesRequiredField.tr();
        }
        if (v.length < 8) {
          return LocaleKeys.messagesPasswordMin8.tr();
        }
        return null;
      },
    );

    final confirmPasswordField = AuthTextField(
      controller: _confirmPasswordController,
      label: LocaleKeys.authConfirmPassword.tr(),
      prefixIcon: Icons.lock_outline,
      obscureText: _obscureConfirm,
      textInputAction: TextInputAction.next,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirm
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
          color: context.colors.textSecondary,
        ),
        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return LocaleKeys.messagesRequiredField.tr();
        }
        if (v != _passwordController.text) {
          return LocaleKeys.messagesPasswordsNotMatch.tr();
        }
        return null;
      },
    );

    final phoneField = AuthTextField(
      controller: _phoneController,
      label: LocaleKeys.authPhoneNumber.tr(),
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.telephoneNumber],
      validator: _requiredValidator,
    );

    final companyField = AuthTextField(
      controller: _companyNameController,
      label: LocaleKeys.authCompanyName.tr(),
      prefixIcon: Icons.business_outlined,
      textInputAction: TextInputAction.next,
      validator: _requiredValidator,
    );

    final jobTitleField = AuthTextField(
      controller: _jobTitleController,
      label: LocaleKeys.authJobTitle.tr(),
      prefixIcon: Icons.badge_outlined,
      textInputAction: TextInputAction.next,
    );

    final countryField = AuthTextField(
      controller: _countryController,
      label: LocaleKeys.authCountry.tr(),
      prefixIcon: Icons.public_outlined,
      textInputAction: TextInputAction.next,
    );

    final cityField = AuthTextField(
      controller: _cityController,
      label: LocaleKeys.authCity.tr(),
      prefixIcon: Icons.location_city_outlined,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _onRegister(),
    );

    if (!isTwoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fullNameField,
          AppSpacing.gapH16,
          emailField,
          AppSpacing.gapH16,
          passwordField,
          AppSpacing.gapH16,
          confirmPasswordField,
          AppSpacing.gapH16,
          phoneField,
          AppSpacing.gapH16,
          companyField,
          AppSpacing.gapH16,
          jobTitleField,
          AppSpacing.gapH16,
          countryField,
          AppSpacing.gapH16,
          cityField,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFormRow(fullNameField, emailField),
        AppSpacing.gapH16,
        _buildFormRow(passwordField, confirmPasswordField),
        AppSpacing.gapH16,
        _buildFormRow(phoneField, companyField),
        AppSpacing.gapH16,
        _buildFormRow(jobTitleField, countryField),
        AppSpacing.gapH16,
        cityField,
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
}
