import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../cubit/add_expense_cubit.dart';
import '../cubit/add_expense_state.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../widgets/expense_form.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.initialLookups,
  });

  final ExpenseFormLookupsViewModel? initialLookups;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddExpenseCubit>().loadLookups(
          preloadedLookups: widget.initialLookups,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state.errorMessage != null) AppToast.error(context, state.errorMessage!);
        if (state.saveSuccess) {
          AppToast.success(context, LocaleKeys.expensesCreatedSuccessfully.tr());
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.expenses);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.expensesAddTitle.tr()),
        ),
        body: BlocBuilder<AddExpenseCubit, AddExpenseState>(
          builder: (context, state) => ExpenseForm(
            state: state,
            cubit: context.read<AddExpenseCubit>(),
            onCancel: () {
              if (context.canPop()) {
                context.pop(false);
              } else {
                context.go(RoutePaths.expenses);
              }
            },
          ),
        ),
      ),
    );
  }
}
