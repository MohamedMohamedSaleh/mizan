import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode.toLowerCase().startsWith('ar');
    final overviewText = isArabic
        ? 'إدارة المصروفات، القيود اليومية، والتقارير من مكان واحد مع رؤية أوضح لحركة الأموال.'
        : 'Manage expenses, journal entries, and reports in one place with clear visibility on your cash flow.';
    final workflowTitle = isArabic ? 'كيف يعمل النظام' : 'How It Works';
    final workflowSteps = isArabic
        ? const [
            'سجل المصروفات والعمليات اليومية بسهولة.',
            'النظام ينظم القيود ويعرض الحالة بشكل فوري.',
            'تابع التقارير واتخذ قرارات أسرع بناءً على البيانات.',
          ]
        : const [
            'Capture expenses and daily operations quickly.',
            'The system structures entries and updates status instantly.',
            'Track reports and make faster data-driven decisions.',
          ];

    return ListView(
      padding: _pagePadding(context),
      children: [
        _FadeSlideIn(
          delayMs: 0,
          child: _HeroPanel(
            overviewText: overviewText,
            typingText: LocaleKeys.appTagline.tr(),
          ),
        ),
        AppSpacing.gapH16,
        _FadeSlideIn(
          delayMs: 120,
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _DashboardMetric(
                icon: Icons.receipt_long_outlined,
                title: LocaleKeys.navExpenses.tr(),
                description: LocaleKeys.dashboardRecentTransactions.tr(),
              ),
              _DashboardMetric(
                icon: Icons.assessment_outlined,
                title: LocaleKeys.navReports.tr(),
                description: LocaleKeys.reportsGenerate.tr(),
              ),
              _DashboardMetric(
                icon: Icons.account_balance_outlined,
                title: LocaleKeys.navGeneralAccounting.tr(),
                description: LocaleKeys.navJournalEntries.tr(),
              ),
            ],
          ),
        ),
        AppSpacing.gapH16,
        _FadeSlideIn(
          delayMs: 240,
          child: _WorkflowPanel(
            title: workflowTitle,
            steps: workflowSteps,
          ),
        ),
      ],
    );
  }
}

class DashboardPlaceholderView extends StatelessWidget {
  const DashboardPlaceholderView({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: _pagePadding(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: AppSpacing.paddingAllXl,
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: AppRadius.borderRadiusBase,
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 44, color: context.colors.primary),
                AppSpacing.gapH16,
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.gapH8,
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.overviewText,
    required this.typingText,
  });

  final String overviewText;
  final String typingText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllXl,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary.withValues(alpha: 0.16),
            context.colors.card,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.navDashboard.tr(),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.gapH8,
          _TypingCursorText(
            text: typingText,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.gapH12,
          Text(
            overviewText,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textPrimary,
              height: 1.45,
            ),
          ),
          AppSpacing.gapH16,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _InfoChip(
                icon: Icons.auto_graph_outlined,
                label: LocaleKeys.navReports.tr(),
              ),
              _InfoChip(
                icon: Icons.receipt_long_outlined,
                label: LocaleKeys.navExpenses.tr(),
              ),
              _InfoChip(
                icon: Icons.account_balance_outlined,
                label: LocaleKeys.navJournalEntries.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkflowPanel extends StatelessWidget {
  const _WorkflowPanel({
    required this.title,
    required this.steps,
  });

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.gapH12,
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (var i = 0; i < steps.length; i++)
                SizedBox(
                  width: context.responsive(mobile: double.infinity, tablet: 300),
                  child: _StepCard(index: i + 1, text: steps[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardMetric extends StatelessWidget {
  const _DashboardMetric({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive(mobile: double.infinity, tablet: 260),
      child: Container(
        padding: AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: AppRadius.borderRadiusBase,
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.colors.primary),
            AppSpacing.gapH12,
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.gapH4,
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingCursorText extends StatefulWidget {
  const _TypingCursorText({
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<_TypingCursorText> createState() => _TypingCursorTextState();
}

class _TypingCursorTextState extends State<_TypingCursorText>
    with TickerProviderStateMixin {
  late final AnimationController _typingController;
  late final AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _typingController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_typingController, _cursorController]),
      builder: (context, _) {
        final visibleChars =
            (_typingController.value * widget.text.length).floor().clamp(
                  0,
                  widget.text.length,
                );
        final typed = widget.text.substring(0, visibleChars);
        final cursorOpacity = _cursorController.value;
        return RichText(
          text: TextSpan(
            style: widget.style ?? context.textTheme.bodyLarge,
            children: [
              TextSpan(text: typed),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Opacity(
                  opacity: cursorOpacity,
                  child: Container(
                    width: 8,
                    height: 18,
                    margin: const EdgeInsetsDirectional.only(start: 4),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({
    required this.delayMs,
    required this.child,
  });

  final int delayMs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, builtChild) {
        final dy = (1 - value) * 14;
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, dy), child: builtChild),
        );
      },
      child: child,
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.inputFill,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$index',
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.colors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

EdgeInsets _pagePadding(BuildContext context) {
  return context.responsive(
    mobile: AppSpacing.pagePaddingMobile,
    tablet: AppSpacing.pagePaddingTablet,
    desktop: AppSpacing.pagePaddingDesktop,
  );
}
