import 'dart:async';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
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
  Timer? _timer;
  int _secondsRemaining = 120;

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 120;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
            _startTimer();
            AppToast.success(context, LocaleKeys.authOtpSentSuccessfully.tr());
          } else if (state is Authenticated) {
            AppToast.success(context, LocaleKeys.authLoginSuccessful.tr());
            context.go(RoutePaths.dashboard);
          } else if (state is AuthError) {
            AppToast.error(context, state.message);
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
    final theme = Theme.of(context);
    final colors = context.colors;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colors.primary, width: 1.4),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: colors.surface,
      ),
    );

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
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verifyOtp(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return LocaleKeys.authOtpRequired.tr();
                  }
                  if (v.trim().length < 6) {
                    return LocaleKeys.authOtpLengthError.tr();
                  }
                  return null;
                },
              ),
            ),
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
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is SendingOtp;
              return TextButton(
                onPressed: (isLoading || _secondsRemaining > 0)
                    ? null
                    : () {
                        context.read<AuthCubit>().sendEmailOtp(email: _email);
                        _startTimer();
                      },
                child: Text(
                  _secondsRemaining > 0
                      ? '${LocaleKeys.authResendOtp.tr()} (${_secondsRemaining}s)'
                      : LocaleKeys.authResendOtp.tr(),
                ),
              );
            },
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
