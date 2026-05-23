import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_preferences_appbar_actions.dart';
import '../widgets/auth_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    TextInput.finishAutofillContext();
    context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        actions: const [AuthPreferencesAppBarActions()],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppToast.error(context, state.message);
          } else if (state is Authenticated) {
            AppToast.success(context, LocaleKeys.authLoginSuccessful.tr());
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingVLg,
              child: AuthFormCard(
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        AppSpacing.gapH32,
                        AuthTextField(
                          controller: _emailController,
                          label: LocaleKeys.authEmail.tr(),
                          hint: 'email@example.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
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
                        AuthTextField(
                          controller: _passwordController,
                          label: LocaleKeys.authPassword.tr(),
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _onLogin(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: context.colors.textSecondary,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
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
                        ),
                        AppSpacing.gapH8,
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () => context.replace(RoutePaths.loginOtp),
                            child: Text(LocaleKeys.authLoginWithOtpEmail.tr()),
                          ),
                        ),
                        AppSpacing.gapH16,
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return AuthPrimaryButton(
                              label: LocaleKeys.authLogin.tr(),
                              isLoading: state is AuthLoading,
                              onPressed: _onLogin,
                            );
                          },
                        ),
                        AppSpacing.gapH24,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.authNoAccount.tr(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                            ),
                            TextButton(
                              onPressed: () => context.replace(RoutePaths.register),
                              child: Text(LocaleKeys.authRegister.tr()),
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
          LocaleKeys.authLogin.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
        ),
      ],
    );
  }
}
