import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../cubit/add_vendor_cubit.dart';
import '../cubit/vendor_form_state.dart';
import '../widgets/vendor_form.dart';

class AddVendorScreen extends StatelessWidget {
  const AddVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddVendorCubit, VendorFormState>(
      listener: (context, state) {
        if (state.saveSuccess) {
          AppToast.success(context, LocaleKeys.vendorsCreatedSuccessfully.tr());
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.vendors);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.vendorsAddTitle.tr()),
        ),
        body: BlocBuilder<AddVendorCubit, VendorFormState>(
          builder: (context, state) => VendorForm(
            state: state,
            cubit: context.read<AddVendorCubit>(),
            title: LocaleKeys.vendorsAddTitle.tr(),
            onCancel: () {
              if (context.canPop()) {
                context.pop(false);
              } else {
                context.go(RoutePaths.vendors);
              }
            },
          ),
        ),
      ),
    );
  }
}
