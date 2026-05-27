import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../cubit/edit_vendor_cubit.dart';
import '../cubit/vendor_form_state.dart';
import '../widgets/vendor_form.dart';

class EditVendorScreen extends StatefulWidget {
  const EditVendorScreen({
    super.key,
    required this.vendorId,
  });

  final String vendorId;

  @override
  State<EditVendorScreen> createState() => _EditVendorScreenState();
}

class _EditVendorScreenState extends State<EditVendorScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EditVendorCubit>().loadVendor(widget.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditVendorCubit, VendorFormState>(
      listener: (context, state) {
        if (state.saveSuccess) {
          AppToast.success(context, LocaleKeys.vendorsUpdatedSuccessfully.tr());
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go(RoutePaths.vendors);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.vendorsEditTitle.tr()),
        ),
        body: BlocBuilder<EditVendorCubit, VendorFormState>(
          builder: (context, state) => VendorForm(
            state: state,
            cubit: context.read<EditVendorCubit>(),
            title: LocaleKeys.vendorsEditTitle.tr(),
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
