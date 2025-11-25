import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/leads/presenter/widget/lead_personal_details.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_details_tile.dart';
import 'package:kommuno/features/leads/presenter/widget/no_record_found.dart';
import 'package:kommuno/features/schedule_call/presenter/page/schedule_calls.dart';
import 'package:kommuno/generated/assets.dart';

class LeadsDetails extends StatelessWidget {
  const LeadsDetails({super.key});

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.leads,
        actions: [BreakInButton.outline()],
      ),
      body: _buildDetailsView(context: context),
    );
  }

  Widget _buildDetailsView({required BuildContext context}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kSized10,
          LeadsDetailsTile(
            leading: const AppSvgPicture(
              assetName: Assets.iconsPerson,
              color: AppColors.appColor,
            ),
            title: AppLocalizations.of(context)!.personalDetails,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.65,
                child: const LeadPersonalDetails(
                  backgroundColor: AppColors.whiteGrey,
                ),
              ),
            ],
          ),
          _kSized10,
          LeadsDetailsTile(
            leading: const AppSvgPicture(
              assetName: Assets.iconsProduct,
              color: AppColors.appColor,
              height: 30,
              width: 30,
            ),
            title: AppLocalizations.of(context)!.productDetails,
            children: const [NoRecordFound()],
          ),
          _kSized10,
          LeadsDetailsTile(
            leading: const AppSvgPicture(
              assetName: Assets.iconsEdit,
              color: AppColors.appColor,
              height: 30,
              width: 30,
            ),
            title: AppLocalizations.of(context)!.remarks,
            children: const [NoRecordFound()],
          ),
          _kSized10,
          LeadsDetailsTile(
            leading: const AppAvatar(
              radius: 15,
              child: AppSvgPicture(
                assetName: Assets.iconsPhoneOutlined,
                color: AppColors.white,
                height: 30,
                width: 30,
              ),
            ),
            title: AppLocalizations.of(context)!.scheduleCalls,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: const ScheduleCalls(
                  backgroundColor: AppColors.whiteGrey,
                  isAddFollowup: true,
                ),
              ),
            ],
          ),
          _kSized10,
          LeadsDetailsTile(
            leading: const AppSvgPicture(
              assetName: Assets.iconsAssignedCall,
              color: AppColors.appColor,
              height: 20,
              width: 30,
            ),
            title: AppLocalizations.of(context)!.callDetails,
            children: const [NoRecordFound()],
          ),
          _kSized20,
        ],
      ),
    );
  }
}
