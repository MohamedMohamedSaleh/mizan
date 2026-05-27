import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/locale_keys.dart';

abstract final class VendorStatusUtils {
  static const String active = 'active';
  static const String inactive = 'inactive';

  static const List<String> all = [active, inactive];

  static String normalize(String? status) {
    final value = status?.trim().toLowerCase();
    if (value == inactive || value == 'unactive') {
      return inactive;
    }
    return active;
  }

  static String label(String? status) {
    return switch (normalize(status)) {
      inactive => LocaleKeys.vendorsStatusInactive.tr(),
      _ => LocaleKeys.vendorsStatusActive.tr(),
    };
  }
}
