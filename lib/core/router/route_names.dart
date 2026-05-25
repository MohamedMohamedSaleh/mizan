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
  static const String expenses = '/expenses';
  static const String addExpense = '/expenses/add';
  static const String expenseDetails = '/expenses/:id';
  static const String editExpense = '/expenses/:id/edit';
}
