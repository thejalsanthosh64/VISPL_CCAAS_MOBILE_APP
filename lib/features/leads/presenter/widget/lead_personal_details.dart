import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/generated/assets.dart';

class LeadPersonalDetails extends StatelessWidget {
  const LeadPersonalDetails({super.key, this.backgroundColor});

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _LeadPersonalDetailsState(backgroundColor: backgroundColor);
  }
}

class _LeadPersonalDetailsState extends StatelessWidget {
  const _LeadPersonalDetailsState({this.backgroundColor});

  final Color? backgroundColor;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.edit,
                )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.name,
                    assetName: Assets.iconsPerson,
                    value: "dfjlk",
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.email,
                    assetName: Assets.iconsEmail,
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.company,
                    assetName: Assets.iconsCompany,
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.city,
                    assetName: Assets.iconsCity,
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.status,
                    assetName: Assets.iconsStatus,
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.totalCalls,
                    assetName: Assets.iconsRecentCalls,
                  ),
                  _kSized10,
                  _PersonalDetailsContainer(
                    title: AppLocalizations.of(context)!.lastCommunication,
                    assetName: Assets.iconsMessage,
                    value: "54",
                  ),
                  _kSized20
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalDetailsContainer extends StatelessWidget {
  const _PersonalDetailsContainer(
      {required this.assetName, required this.title, this.value});

  final String assetName;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppConstant.kSized55,
        maxHeight: 110,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appColor),
        borderRadius: BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppSvgPicture(
            assetName: assetName,
            height: 20,
            width: 20,
            color: AppColors.appColor,
          ),
          const SizedBox(width: 7),
          Padding(
            padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
            child: Text(
              "$title : ",
              style: AppTextStyle.appColor16,
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
              child: Text(
                value ?? '',
                style: AppTextStyle.black16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
