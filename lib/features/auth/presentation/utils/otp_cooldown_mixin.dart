import 'dart:async';

import 'package:flutter/material.dart';

mixin OtpCooldownMixin<T extends StatefulWidget> on State<T> {
  static const int defaultCooldownSeconds = 60;

  Timer? _cooldownTimer;
  int _secondsRemaining = 0;

  int get secondsRemaining => _secondsRemaining;
  bool get isCooldownActive => _secondsRemaining > 0;

  void startOtpCooldown([int seconds = defaultCooldownSeconds]) {
    _cooldownTimer?.cancel();
    setState(() {
      _secondsRemaining = seconds;
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        setState(() {
          _secondsRemaining = 0;
        });
        timer.cancel();
        return;
      }
      setState(() {
        _secondsRemaining--;
      });
    });
  }

  void disposeOtpCooldown() {
    _cooldownTimer?.cancel();
  }
}
