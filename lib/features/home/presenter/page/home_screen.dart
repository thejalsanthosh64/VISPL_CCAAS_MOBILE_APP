import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/logout_manager.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';
import 'package:kommuno/features/break/presenter/view/break_status_container.dart';
import 'package:kommuno/features/break/presenter/view/break_widget.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/onboarding_widget/onboarding_widget.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/home/presenter/widget/home_button.dart';
import 'package:kommuno/features/home/presenter/widget/home_menu_button.dart';
import 'package:kommuno/features/home/presenter/widget/home_progress.dart';
import 'package:kommuno/features/home/presenter/widget/on_board_conatiner.dart';
import 'package:kommuno/generated/assets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.applicationName,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: AppConstant.kBodyHorizontalPadding),
          child: AppAvatar(
            backgroundColor: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(Assets.imagesAppLogo),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              LogoutManager.logoutDialog(context: context);
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.white,
            ),
          ),
          const HomeMenuButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.kBodyHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kSized5,
            _buildAppBar(context: context, userDetails: userDetails),
            _kSized5,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<UserDetailsCubit>()
                      .loadUserDetails(isLoading: false);
                  if (context.mounted) {
                    await context
                        .read<BreakCubit>()
                        .getBreakDetails(isLoading: false);
                  }
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _kSized5,
                      _buildTimeView(
                          context: context, userDetails: userDetails),
                      _kSized10,
                      _buildOnboarding(),
                      _kSized5,
                      ..._buildButtons1(context: context),
                      _kSized10,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
      {required BuildContext context, required UserDetailsModel userDetails}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppAvatar(
                    child: Text(
                        userDetails.agentName.capitalizeFirstLetterOfTwoWords,
                        style: AppTextStyle.whiteNormal),
                  ),
                  // const BreakStatusContainer()
                ],
              ),
              const SizedBox(width: AppConstant.kSized15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(userDetails.agentName,
                      style: AppTextStyle.appColorNormal),
                  Text(
                      addByIndiaCountryCodeWithoutPlus(
                          number: userDetails.agentMobile),
                      style: AppTextStyle.appColorNormal),
                  _kSized10,
                ],
              )
            ],
          ),
        ),
        BreakInButton.filled()
      ],
    );
  }

  Widget _buildTimeView(
      {required BuildContext context, required UserDetailsModel userDetails}) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: BreakWidget()),
        /*_kSized15,
        HomeProgress(
          progress: (userDetails.agentScore ?? 0).toDouble(),
        )*/
      ],
    );
  }

  Widget _buildOnboarding() {
    return const SizedBox(
      height: 120,
      child: OnboardingWidget(
        content: [
          OnBoardConatiner(),
          OnBoardConatiner(),
          OnBoardConatiner(),
        ],
      ),
    );
  }

  List<Widget> _buildButtons({required BuildContext context}) {
    return [
      Row(
        children: [
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.assignedCalls,
              iconPath: Assets.iconsAssignedCall,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.assignedCalls);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.dial,
              iconPath: Assets.iconsDial,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.dialScreen);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.insights,
              iconPath: Assets.iconsInsights,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.inSights);
              },
            ),
          ),
        ],
      ),
      _kSized10,
      Row(
        children: [
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.recentCalls,
              iconPath: Assets.iconsRecentCalls,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.recentCalls);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.followUp,
              iconPath: Assets.iconsFollowUp,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.followUp);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.contacts,
              iconPath: Assets.iconsContacts,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.contactList);
              },
            ),
          ),
        ],
      ),
      _kSized10,
      Row(
        children: [
          const Expanded(
            child: SizedBox(
              width: HomeButton.width,
              height: HomeButton.height,
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.leads,
              iconPath: Assets.iconsLeads,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.leads);
              },
            ),
          ),
          _kSized15,
          const Expanded(
            child: SizedBox(
              width: HomeButton.width,
              height: HomeButton.height,
            ),
          ),
        ],
      ),
      _kSized10,
    ];
  }

  List<Widget> _buildButtons1({required BuildContext context}) {
    return [
      Row(
        children: [
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.dial,
              iconPath: Assets.iconsDial,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.dialScreen);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.insights,
              iconPath: Assets.iconsInsights,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.inSights);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.recentCalls,
              iconPath: Assets.iconsRecentCalls,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.recentCalls);
              },
            ),
          ),
        ],
      ),
      _kSized10,
      Row(
        children: [
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.followUp,
              iconPath: Assets.iconsFollowUp,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.followUp);
              },
            ),
          ),
          _kSized15,
          Expanded(
            child: HomeButton(
              text: AppLocalizations.of(context)!.contacts,
              iconPath: Assets.iconsContacts,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouteNames.contactList);
              },
            ),
          ),
          _kSized15,
          const Expanded(
            child: SizedBox(
              width: HomeButton.width,
              height: HomeButton.height,
            ),
          ),
        ],
      ),
      _kSized10,
    ];
  }
}
