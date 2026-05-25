import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../cubit/add_expense_state.dart';
import '../cubit/edit_expense_cubit.dart';
import '../widgets/expense_form.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key, required this.expenseId});

  final String expenseId;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EditExpenseCubit>().loadExpense(widget.expenseId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditExpenseCubit, AddExpenseState>(
      listener: (context, state) {
        if (state.errorMessage != null) AppToast.error(context, state.errorMessage!);
        if (state.saveSuccess) {
          AppToast.success(context, LocaleKeys.expensesUpdatedSuccessfully.tr());
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.expenses);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.expensesEditTitle.tr()),
        ),
        body: BlocBuilder<EditExpenseCubit, AddExpenseState>(
          builder: (context, state) => ExpenseForm(
            state: state,
            cubit: context.read<EditExpenseCubit>(),
            showSavedWarning: true,
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
