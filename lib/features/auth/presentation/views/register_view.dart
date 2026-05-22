
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
  final _businessNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _businessNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          businessName: _businessNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
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
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingVLg,
              child: AuthFormCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Header ──
                      _buildHeader(context),
                      AppSpacing.gapH32,

                      // ── Business Name ──
                      AuthTextField(
                        controller: _businessNameController,
                        label: LocaleKeys.authBusinessName.tr(),
                        prefixIcon: Icons.business_outlined,
                        textInputAction: TextInputAction.next,
                        validator: _requiredValidator,
                      ),
                      AppSpacing.gapH16,

                      // ── Full Name ──
                      AuthTextField(
                        controller: _fullNameController,
                        label: LocaleKeys.authFullName.tr(),
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: _requiredValidator,
                      ),
                      AppSpacing.gapH16,

                      // ── Email ──
                      AuthTextField(
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
                          if (!v.contains('@')) {
                            return LocaleKeys.messagesInvalidEmail.tr();
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapH16,

                      // ── Phone ──
                      AuthTextField(
                        controller: _phoneController,
                        label: LocaleKeys.authPhoneNumber.tr(),
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        validator: _requiredValidator,
                      ),
                      AppSpacing.gapH16,

                      // ── Password ──
                      AuthTextField(
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
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return LocaleKeys.messagesRequiredField.tr();
                          }
                          if (v.length < 6) {
                            return LocaleKeys.messagesPasswordMin.tr();
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapH16,

                      // ── Confirm Password ──
                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: LocaleKeys.authConfirmPassword.tr(),
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: context.colors.textSecondary,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        onFieldSubmitted: (_) => _onRegister(),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return LocaleKeys.messagesRequiredField.tr();
                          }
                          if (v != _passwordController.text) {
                            return LocaleKeys.messagesPasswordsNotMatch.tr();
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapH24,

                      // ── Register Button ──
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

                      // ── Login Link ──
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
                            onPressed: () => context.goNamed(RouteNames.login),
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
}
