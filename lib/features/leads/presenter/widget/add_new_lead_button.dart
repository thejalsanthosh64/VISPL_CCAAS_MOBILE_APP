import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/leads/data/model/request/add_lead_request_model.dart';
import 'package:kommuno/features/leads/presenter/page/add_new_lead.dart';
import 'package:kommuno/generated/assets.dart';

class AddNewLeadButton extends StatelessWidget {
  const AddNewLeadButton({
    super.key,
    this.onAddNewLead,
  });

  final void Function(AddMannualLeadRequestModel addNewLead)? onAddNewLead;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final res = await appBottomSheet(
          child: (ctx) => const AddNewLead(),
          height: 315,
          context: context,
        );

        if (onAddNewLead != null && res is AddMannualLeadRequestModel) {
          onAddNewLead!(res);
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
          Text(AppLocalizations.of(context)!.addLead),
        ],
      ),
    );
  }
}
