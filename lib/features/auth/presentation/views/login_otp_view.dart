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

class LoginOtpView extends StatefulWidget {
  const LoginOtpView({super.key});

  @override
  State<LoginOtpView> createState() => _LoginOtpViewState();
}

class _LoginOtpViewState extends State<LoginOtpView> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  bool _otpSent = false;
  String _email = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_emailFormKey.currentState!.validate()) return;
    _email = _emailController.text.trim();
    context.read<AuthCubit>().sendEmailOtp(email: _email);
  }

  void _verifyOtp() {
    if (!_otpFormKey.currentState!.validate()) return;
    context.read<AuthCubit>().verifyEmailOtp(
          email: _email,
          otp: _otpController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            setState(() {
              _otpSent = true;
              _email = state.email;
            });
            context.showSnackBar(LocaleKeys.authOtpSentSuccessfully.tr());
          } else if (state is Authenticated) {
            context.go(RoutePaths.dashboard);
          } else if (state is AuthError) {
            context.showSnackBar(state.message);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingVLg,
              child: AuthFormCard(
                child: _otpSent ? _buildOtpForm(context) : _buildEmailForm(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.authLoginWithOtpEmail.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH12,
          Text(
            LocaleKeys.authEnterEmailToReceiveOtp.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH24,
          AuthTextField(
            controller: _emailController,
            label: LocaleKeys.authEmail.tr(),
            hint: 'email@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _sendOtp(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return LocaleKeys.messagesRequiredField.tr();
              }
              final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
              if (!emailRegex.hasMatch(v.trim())) {
                return LocaleKeys.authInvalidEmail.tr();
              }
              return null;
            },
          ),
          AppSpacing.gapH24,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is SendingOtp;
              return AuthPrimaryButton(
                label: LocaleKeys.authSendOtp.tr(),
                isLoading: isLoading,
                onPressed: _sendOtp,
              );
            },
          ),
          AppSpacing.gapH12,
          TextButton(
            onPressed: () => context.replace(RoutePaths.login),
            child: Text(LocaleKeys.authBackToLogin.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.authEnterOtpCode.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH12,
          Text(
            _email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH24,
          AuthTextField(
            controller: _otpController,
            label: LocaleKeys.authEnterOtpCode.tr(),
            prefixIcon: Icons.password_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _verifyOtp(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return LocaleKeys.authOtpRequired.tr();
              }
              return null;
            },
          ),
          AppSpacing.gapH24,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is VerifyingOtp;
              return AuthPrimaryButton(
                label: LocaleKeys.authVerifyOtp.tr(),
                isLoading: isLoading,
                onPressed: _verifyOtp,
              );
            },
          ),
          AppSpacing.gapH12,
          TextButton(
            onPressed: () => context.read<AuthCubit>().sendEmailOtp(email: _email),
            child: Text(LocaleKeys.authResendOtp.tr()),
          ),
          TextButton(
            onPressed: () => context.replace(RoutePaths.login),
            child: Text(LocaleKeys.authBackToLogin.tr()),
          ),
        ],
      ),
    );
  }
}
