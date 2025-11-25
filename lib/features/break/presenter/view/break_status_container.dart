import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class BreakStatusContainer extends StatelessWidget {
  const BreakStatusContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreakCubit, BreakState>(
      builder: (context, state) {
        if (state is BreakSuccessState) {
          final status = _getStatusData(
              status: state.breakResponseModel.status, context: context);
          return Text(
            status.$1,
            style: AppTextStyle.appColorNormal.copyWith(color: status.$2),
          );
        }
        return const SizedBox();
      },
    );
  }

  (String value, Color color) _getStatusData(
      {int? status, required BuildContext context}) {
    switch (status) {
      case 0:
        return (AppLocalizations.of(context)!.inActive, AppColors.black);
      case 1:
        return (AppLocalizations.of(context)!.idle, AppColors.appColor);
      case 2:
        return (AppLocalizations.of(context)!.busy, AppColors.red);
      case 3:
        return (AppLocalizations.of(context)!.offHours, AppColors.blue);
      case 4:
        return (AppLocalizations.of(context)!.breakText, AppColors.orange);
      default:
        return (AppLocalizations.of(context)!.idle, AppColors.appColor);
    }
  }
}
