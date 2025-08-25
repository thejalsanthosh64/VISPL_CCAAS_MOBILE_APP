import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/features/schedule_call/cubit/schedule_cubit/schedule_cubit.dart';
import 'package:kommuno/features/schedule_call/presenter/widget/schedule_call_list_tile.dart';

class ScheduleCalls extends StatelessWidget {
  const ScheduleCalls({
    super.key,
    this.backgroundColor,
    this.isAddFollowup = false,
  });

  final Color? backgroundColor;
  final bool isAddFollowup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit(),
      child: _ScheduleCallsState(
        backgroundColor: backgroundColor,
        isAddFollowup: isAddFollowup,
      ),
    );
  }
}

class _ScheduleCallsState extends StatelessWidget {
  const _ScheduleCallsState({
    this.backgroundColor,
    required this.isAddFollowup,
  });

  final Color? backgroundColor;

  final bool isAddFollowup;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  ScheduleCubit _scheduleCubit(BuildContext context) =>
      context.read<ScheduleCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    return DefaultTabController(
      length: 3,
      child:
          BlocBuilder<ScheduleCubit, ScheduleState>(builder: (context, state) {
        if (state is ScheduleInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _scheduleCubit(context).getScheduleCalls(smeId: smeId);
              }
            },
          );
        } else if (state is ScheduleLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is ScheduleErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _scheduleCubit(context).getScheduleCalls(smeId: smeId);
            },
          );
        } else if (state is ScheduleSuccessState) {
          return Column(
            children: [
              if (isAddFollowup)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.followUp,
                    ),
                  ),
                ),
              _buildTabBar(context: context),
              _kSized10,
              Expanded(
                child: _buildTabBarView(state: state, context: context),
              )
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _buildTabBar({required BuildContext context}) {

    return TabBar(
      dividerColor: AppColors.transparent,
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      splashBorderRadius:
          BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
              AppConstant.kFieldAndButtonRadius), // Creates border
          color: AppColors.appColor),
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: AppColors.black,
      labelColor: AppColors.whiteGrey,
      tabs:  [
        Tab(child: Text(AppLocalizations.of(context)!.past)),
        Tab(child: Text(AppLocalizations.of(context)!.today)),
        Tab(child: Text(AppLocalizations.of(context)!.upcoming)),
      ],
    );
  }

  Widget _buildTabBarView(
      {required ScheduleSuccessState state, required BuildContext context}) {
    return TabBarView(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: state.scheduleCallsResponseModel.pastSchedule.length,
          itemBuilder: (__, index) {
            return ScheduleCallListTile(
              index: index,
              scheduleCallDetail:
                  state.scheduleCallsResponseModel.pastSchedule[index],
            );
          },
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: state.scheduleCallsResponseModel.todaySchedule.length,
          itemBuilder: (__, index) {
            return ScheduleCallListTile(
              index: index,
              scheduleCallDetail:
                  state.scheduleCallsResponseModel.todaySchedule[index],
            );
          },
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: state.scheduleCallsResponseModel.upcomingSchedule.length,
          itemBuilder: (__, index) {
            return ScheduleCallListTile(
              index: index,
              scheduleCallDetail:
                  state.scheduleCallsResponseModel.upcomingSchedule[index],
            );
          },
        ),
      ],
    );
  }
}
