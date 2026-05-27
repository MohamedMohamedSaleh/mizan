/// Named route constants — use these with `context.goNamed()`.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String loginOtp = 'login-otp';
  static const String verifyRegisterOtp = 'verify-register-otp';
  static const String forgotPassword = 'forgot-password';
  static const String dashboard = 'dashboard';
  static const String expenses = 'expenses';
  static const String addExpense = 'add-expense';
  static const String expenseDetails = 'expense-details';
  static const String editExpense = 'edit-expense';
  static const String vendors = 'vendors';
  static const String addVendor = 'add-vendor';
  static const String editVendor = 'edit-vendor';
  static const String reports = 'reports';
  static const String journalEntries = 'journal-entries';
  static const String accounts = 'accounts';
  static const String settings = 'settings';
}

/// Route path constants.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String loginOtp = '/login-otp';
  static const String verifyRegisterOtp = '/verify-register-otp';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String expenses = '/dashboard/expenses';
  static const String addExpense = '/dashboard/expenses/add';
  static const String expenseDetails = '/dashboard/expenses/:id';
  static const String editExpense = '/dashboard/expenses/:id/edit';
  static const String vendors = '/vendors';
  static const String addVendor = '/vendors/add';
  static const String editVendor = '/vendors/:id/edit';
  static const String reports = '/dashboard/reports';
  static const String journalEntries = '/dashboard/journal-entries';
  static const String accounts = '/dashboard/accounts';
  static const String settings = '/dashboard/settings';
}
