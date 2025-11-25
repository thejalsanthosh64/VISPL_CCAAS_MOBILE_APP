import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/features/schedule_call/data/model/request/add_schedule_call_request_model.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class AddNewFollowUpButton extends StatelessWidget {
  const AddNewFollowUpButton({
    super.key,
    this.onAddNewFollowup,
  });

  final void Function(AddScheduleCallRequestModel followUpDetail)?
      onAddNewFollowup;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final newScheduleCallDetails = await Navigator.of(context)
            .pushNamed(AppRouteNames.addScheduleCall);
        if (newScheduleCallDetails is AddScheduleCallRequestModel &&
            onAddNewFollowup != null) {
          onAddNewFollowup!(newScheduleCallDetails);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppSvgPicture(
            assetName: Assets.iconsAddNew,
            color: AppColors.appColor,
          ),
          const SizedBox(width: AppConstant.kSized15),
          Text(AppLocalizations.of(context)!.addNew),
        ],
      ),
    );
  }
}
