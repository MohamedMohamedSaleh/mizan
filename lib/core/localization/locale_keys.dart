/// Central registry of all translation keys used in the app.
///
/// Instead of hardcoding `'nav.dashboard'.tr()` in widgets, use:
/// ```dart
/// LocaleKeys.navDashboard.tr()
/// ```
/// This gives compile-time safety â€” a typo in a key becomes a
/// compile error rather than a silent missing-translation at runtime.
abstract final class LocaleKeys {
  static const String switchToLight = 'switch_to_light';
  static const String switchToDark = 'switch_to_dark';
  static const String changeLanguage = 'change_language';
  static const String english = 'english';
  static const String arabic = 'arabic';
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ App â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String appName = 'app.name';
  static const String appTagline = 'app.tagline';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Navigation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String navDashboard = 'nav.dashboard';
  static const String navFinance = 'nav.finance';
  static const String navExpenses = 'nav.expenses';
  static const String navAddExpense = 'nav.add_expense';
  static const String navGeneralAccounting = 'nav.general_accounting';
  static const String navJournalEntries = 'nav.journal_entries';
  static const String navAddJournalEntry = 'nav.add_journal_entry';
  static const String navReports = 'nav.reports';
  static const String navAccounts = 'nav.accounts';
  static const String navSettings = 'nav.settings';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Auth â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String authLogin = 'auth.login';
  static const String authRegister = 'auth.register';
  static const String authLogout = 'auth.logout';
  static const String authEmail = 'auth.email';
  static const String authPassword = 'auth.password';
  static const String authConfirmPassword = 'auth.confirm_password';
  static const String authFullName = 'auth.full_name';
  static const String authBusinessName = 'auth.business_name';
  static const String authCompanyName = 'auth.company_name';
  static const String authPhoneNumber = 'auth.phone_number';
  static const String authPhoneNumberRequired = 'auth.phone_number_required';
  static const String authInvalidPhoneNumber = 'auth.invalid_phone_number';
  static const String authSaudiPhoneLengthError = 'auth.saudi_phone_length_error';
  static const String authEgyptPhoneLengthError = 'auth.egypt_phone_length_error';
  static const String authSelectCountry = 'auth.select_country';
  static const String authJobTitle = 'auth.job_title';
  static const String authCountry = 'auth.country';
  static const String authCity = 'auth.city';
  static const String authAcceptTerms = 'auth.accept_terms';
  static const String authAcceptTermsRequired = 'auth.accept_terms_required';
  static const String authEmailConfirmationRequired =
      'auth.email_confirmation_required';
  static const String authForgotPassword = 'auth.forgot_password';
  static const String authLoginWithOtpEmail = 'auth.login_with_otp_email';
  static const String authEnterEmailToReceiveOtp =
      'auth.enter_email_to_receive_otp';
  static const String authSendOtp = 'auth.send_otp';
  static const String authOtpSentSuccessfully = 'auth.otp_sent_successfully';
  static const String authEnterOtpCode = 'auth.enter_otp_code';
  static const String authVerifyOtp = 'auth.verify_otp';
  static const String authResendOtp = 'auth.resend_otp';
  static const String authBackToLogin = 'auth.back_to_login';
  static const String authInvalidEmail = 'auth.invalid_email';
  static const String authOtpRequired = 'auth.otp_required';
  static const String authOtpLengthError = 'auth.otp_length_error';
  static const String authInvalidOrExpiredOtp = 'auth.invalid_or_expired_otp';
  static const String authNoAccountFoundForEmail = 'auth.no_account_found_for_email';
  static const String authLoginSuccessful = 'auth.login_successful';
  static const String authVerifyEmail = 'auth.verify_email';
  static const String authEnterOtpSentToEmail = 'auth.enter_otp_sent_to_email';
  static const String authOtpCode = 'auth.otp_code';
  static const String authVerify = 'auth.verify';
  static const String authOtpVerifiedSuccessfully = 'auth.otp_verified_successfully';
  static const String authCheckYourEmailForOtp = 'auth.check_your_email_for_otp';
  static const String authBackToRegister = 'auth.back_to_register';
  static const String authResetPassword = 'auth.reset_password';
  static const String authResetPasswordDesc = 'auth.reset_password_desc';
  static const String authResetPasswordSuccess = 'auth.reset_password_success';
  static const String authSendResetLink = 'auth.send_reset_link';
  static const String authNoAccount = 'auth.no_account';
  static const String authHaveAccount = 'auth.have_account';
  static const String authLoginSuccess = 'auth.login_success';
  static const String authRegisterSuccess = 'auth.register_success';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Fields â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String fieldsAmount = 'fields.amount';
  static const String fieldsDate = 'fields.date';
  static const String fieldsCode = 'fields.code';
  static const String fieldsDescription = 'fields.description';
  static const String fieldsCategory = 'fields.category';
  static const String fieldsVendor = 'fields.vendor';
  static const String fieldsCustomer = 'fields.customer';
  static const String fieldsSupplier = 'fields.supplier';
  static const String fieldsSubAccount = 'fields.sub_account';
  static const String fieldsTax = 'fields.tax';
  static const String fieldsAttachment = 'fields.attachment';
  static const String fieldsNote = 'fields.note';
  static const String fieldsReference = 'fields.reference';
  static const String fieldsStatus = 'fields.status';
  static const String fieldsType = 'fields.type';
  static const String fieldsName = 'fields.name';
  static const String fieldsNumber = 'fields.number';
  static const String fieldsBalance = 'fields.balance';
  static const String fieldsCurrency = 'fields.currency';
  static const String fieldsFromDate = 'fields.from_date';
  static const String fieldsToDate = 'fields.to_date';
  static const String fieldsPaymentMethod = 'fields.payment_method';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Accounting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String accountingDebit = 'accounting.debit';
  static const String accountingCredit = 'accounting.credit';
  static const String accountingTotalDebit = 'accounting.total_debit';
  static const String accountingTotalCredit = 'accounting.total_credit';
  static const String accountingDifference = 'accounting.difference';
  static const String accountingBalanced = 'accounting.balanced';
  static const String accountingNotBalanced = 'accounting.not_balanced';
  static const String accountingJournalLine = 'accounting.journal_line';
  static const String accountingAddLine = 'accounting.add_line';
  static const String accountingRemoveLine = 'accounting.remove_line';
  static const String accountingAccount = 'accounting.account';
  static const String accountingExpenseAccount = 'accounting.expense_account';
  static const String accountingCashAccount = 'accounting.cash_account';
  static const String accountingBankAccount = 'accounting.bank_account';
  static const String accountingPosted = 'accounting.posted';
  static const String accountingDraft = 'accounting.draft';
  static const String accountingVoid = 'accounting.void';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String actionsSave = 'actions.save';
  static const String actionsCancel = 'actions.cancel';
  static const String actionsSaveAsDraft = 'actions.save_as_draft';
  static const String actionsDelete = 'actions.delete';
  static const String actionsEdit = 'actions.edit';
  static const String actionsPrint = 'actions.print';
  static const String actionsSearch = 'actions.search';
  static const String actionsFilter = 'actions.filter';
  static const String actionsRefresh = 'actions.refresh';
  static const String actionsAdd = 'actions.add';
  static const String actionsClose = 'actions.close';
  static const String actionsConfirm = 'actions.confirm';
  static const String actionsBack = 'actions.back';
  static const String actionsNext = 'actions.next';
  static const String actionsPrevious = 'actions.previous';
  static const String actionsSelect = 'actions.select';
  static const String actionsUpload = 'actions.upload';
  static const String actionsDownload = 'actions.download';
  static const String actionsExport = 'actions.export';
  static const String actionsImport = 'actions.import';
  static const String actionsViewAll = 'actions.view_all';
  static const String actionsShowMore = 'actions.show_more';
  static const String actionsShowLess = 'actions.show_less';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Messages â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String messagesSuccess = 'messages.success';
  static const String messagesError = 'messages.error';
  static const String messagesConfirmDelete = 'messages.confirm_delete';
  static const String messagesNoData = 'messages.no_data';
  static const String messagesLoading = 'messages.loading';
  static const String messagesSaving = 'messages.saving';
  static const String messagesRequiredField = 'messages.required_field';
  static const String messagesInvalidEmail = 'messages.invalid_email';
  static const String messagesPasswordMin = 'messages.password_min';
  static const String messagesPasswordMin8 = 'messages.password_min_8';
  static const String messagesPasswordsNotMatch = 'messages.passwords_not_match';
  static const String messagesEntryNotBalanced = 'messages.entry_not_balanced';
  static const String messagesEntrySaved = 'messages.entry_saved';
  static const String messagesExpenseSaved = 'messages.expense_saved';
  static const String messagesDeletedSuccessfully = 'messages.deleted_successfully';
  static const String messagesNetworkError = 'messages.network_error';
  static const String messagesOfflineMode = 'messages.offline_mode';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Reports â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String reportsExpenseReport = 'reports.expense_report';
  static const String reportsJournalReport = 'reports.journal_report';
  static const String reportsTotal = 'reports.total';
  static const String reportsPeriod = 'reports.period';
  static const String reportsDaily = 'reports.daily';
  static const String reportsWeekly = 'reports.weekly';
  static const String reportsMonthly = 'reports.monthly';
  static const String reportsYearly = 'reports.yearly';
  static const String reportsCustom = 'reports.custom';
  static const String reportsGenerate = 'reports.generate';
  static const String reportsNoReportData = 'reports.no_report_data';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Settings â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String settingsTitle = 'settings.title';
  static const String settingsLanguage = 'settings.language';
  static const String settingsArabic = 'settings.arabic';
  static const String settingsEnglish = 'settings.english';
  static const String settingsTheme = 'settings.theme';
  static const String settingsDarkMode = 'settings.dark_mode';
  static const String settingsLightMode = 'settings.light_mode';
  static const String settingsSystemMode = 'settings.system_mode';
  static const String settingsAbout = 'settings.about';
  static const String settingsVersion = 'settings.version';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Dashboard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String dashboardWelcome = 'dashboard.welcome';
  static const String dashboardTotalExpenses = 'dashboard.total_expenses';
  static const String dashboardTotalEntries = 'dashboard.total_entries';
  static const String dashboardRecentTransactions = 'dashboard.recent_transactions';
  static const String dashboardQuickActions = 'dashboard.quick_actions';
  static const String dashboardOverview = 'dashboard.overview';
}

