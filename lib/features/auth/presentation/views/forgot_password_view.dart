import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().forgotPassword(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(RouteNames.login),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSent) {
            AppToast.success(context, LocaleKeys.authResetPasswordSuccess.tr());
            context.goNamed(RouteNames.login);
          } else if (state is AuthError) {
            AppToast.error(context, state.message);
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

                      // ── Email ──
                      AuthTextField(
                        controller: _emailController,
                        label: LocaleKeys.authEmail.tr(),
                        hint: 'email@example.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        onFieldSubmitted: (_) => _onSubmit(),
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
                      AppSpacing.gapH24,

                      // ── Submit Button ──
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return AuthPrimaryButton(
                            label: LocaleKeys.authSendResetLink.tr(),
                            isLoading: state is AuthLoading,
                            onPressed: _onSubmit,
                          );
                        },
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
          Icons.lock_reset_outlined,
          size: 48,
          color: context.colors.primary,
        ),
        AppSpacing.gapH12,
        Text(
          LocaleKeys.authResetPassword.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        AppSpacing.gapH8,
        Text(
          LocaleKeys.authResetPasswordDesc.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
        ),
      ],
    );
  }
}
