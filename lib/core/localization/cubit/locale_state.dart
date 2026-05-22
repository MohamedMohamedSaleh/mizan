import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State for [LocaleCubit].
class LocaleState extends Equatable {
  const LocaleState({required this.locale});

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
