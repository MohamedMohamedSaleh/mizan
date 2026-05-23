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

  @override
  void dispose() {
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
                      AuthTextField(
                        controller: _otpController,
                        label: LocaleKeys.authOtpCode.tr(),
                        prefixIcon: Icons.password_outlined,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _verify(),
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
                            onPressed: loading
                                ? null
                                : () => context
                                    .read<AuthCubit>()
                                    .resendRegisterOtp(email: widget.payload.email),
                            child: Text(LocaleKeys.authResendOtp.tr()),
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
