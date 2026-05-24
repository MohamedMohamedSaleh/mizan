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

class VerifyRegisterOtpView extends StatefulWidget {
  const VerifyRegisterOtpView({
    super.key,
    required this.payload,
  });

  final RegisterOtpPayload payload;

  @override
  State<VerifyRegisterOtpView> createState() => _VerifyRegisterOtpViewState();
}

class _VerifyRegisterOtpViewState extends State<VerifyRegisterOtpView> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

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
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().verifyRegisterOtp(
          payload: widget.payload,
          otp: _otpController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            AppToast.error(context, state.message);
          } else if (state is ResendOtpSuccess) {
            AppToast.info(context, LocaleKeys.authCheckYourEmailForOtp.tr());
          } else if (state is RegisterSuccess || state is Authenticated) {
            AppToast.success(context, LocaleKeys.authOtpVerifiedSuccessfully.tr());
            context.go(RoutePaths.dashboard);
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.authVerifyEmail.tr(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.gapH12,
                      Text(
                        LocaleKeys.authEnterOtpSentToEmail.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                      ),
                      AppSpacing.gapH8,
                      Text(
                        widget.payload.email,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.colors.textSecondary,
                            ),
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
                            onSubmitted: (_) => _verify(),
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
                          return AuthPrimaryButton(
                            label: LocaleKeys.authVerify.tr(),
                            isLoading: state is RegisterOtpVerifying,
                            onPressed: _verify,
                          );
                        },
                      ),
                      AppSpacing.gapH12,
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final loading = state is ResendOtpLoading;
                          return TextButton(
                            onPressed: (loading || _secondsRemaining > 0)
                                ? null
                                : () {
                                    context
                                        .read<AuthCubit>()
                                        .resendRegisterOtp(email: widget.payload.email);
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
                        onPressed: () => context.replace(RoutePaths.register),
                        child: Text(LocaleKeys.authBackToRegister.tr()),
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
}
