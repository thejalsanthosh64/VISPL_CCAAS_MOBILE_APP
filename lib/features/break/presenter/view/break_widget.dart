import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';
import 'package:kommuno/features/break/presenter/widget/time_container.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

import 'break_in_button.dart';

class BreakWidget extends StatelessWidget {
  const BreakWidget({super.key});

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  BreakCubit _breakCubit(BuildContext context) => context.read<BreakCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BreakCubit, BreakState>(
      listener: (context, state) {
        if (state is BreakSuccessState) {
          if (state.isOnBreak) {
            _buildBreakDialog(context: context);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      listenWhen: (previous, current) {
        if (previous is BreakSuccessState && current is BreakSuccessState) {
          return previous.isOnBreak != current.isOnBreak;
        }
        return false;
      },
      builder: (context, state) {
        if (state is BreakInitial) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _breakCubit(context).getBreakDetails();
              }
            },
          );
        } else if (state is BreakLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is BreakErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _breakCubit(context).getBreakDetails();
            },
          );
        } else if (state is BreakSuccessState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
               
                // TimeContainer(
                //     title: AppLocalizations.of(context)!.timeOut,
                //     time: state.breakResponseModel.signOutStr ??
                //         AppConstant.breakDefaultTime,
                //   ),
                                   
                  // TimeContainer(
                  //   title: AppLocalizations.of(context)!.timeIn,
                  //   time: state.breakResponseModel.signInStr ??
                  //       AppConstant.breakDefaultTime,
                  // ),
                 TimeContainer(
  title: AppLocalizations.of(context)!.activeTime,
  time: () {
    final userState = context.watch<UserDetailsCubit>().state;

    int office = 0;
    int active = 0;

    if (userState is UserDetailsSuccessState) {
      office = userState.officeHours;      
      active = userState.activeSeconds;    
    }

    final total = office + active;
  // print(" officeHours: $office, activeSeconds: $active, total: $total");

    return total > 0
        ? getDurationFromSeconds(duration: total, isShowText: false)
        : AppConstant.breakDefaultTime;
  }(),
),
 TimeContainer(
                    title: AppLocalizations.of(context)!.breakTime,
                    time: state.breakTime > 0
                        ? getDurationFromSeconds(
                            duration: state.breakTime, isShowText: false)
                        : AppConstant.breakDefaultTime,
                  ),

                ],
              ),
              _kSized15,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
                  // TimeContainer(
                  //   title: AppLocalizations.of(context)!.timeOut,
                  //   time: state.breakResponseModel.signOutStr ??
                  //       AppConstant.breakDefaultTime,
                  // ),
                  // TimeContainer(
                  //   title: AppLocalizations.of(context)!.breakTime,
                  //   time: state.breakTime > 0
                  //       ? getDurationFromSeconds(
                  //           duration: state.breakTime, isShowText: false)
                  //       : AppConstant.breakDefaultTime,
                  // ),
                ],
            //   ),
            // ],
          );
        }
        return const SizedBox();
      },
    );
  }

  void _buildBreakDialog({required BuildContext context}) {
    appDialog(
      context: context,
      constraints: const BoxConstraints(maxHeight: 160),
      customBody: BlocBuilder<BreakCubit, BreakState>(
        bloc: context.read<BreakCubit>(),
        builder: (__, state) {
          if (state is BreakSuccessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.onBreakMsg),
                  _kSized10,
                  const Icon(
                    Icons.coffee,
                    color: AppColors.appColor,
                  ),
                  Text(
                    state.breakTime > 0
                        ? getDurationFromSeconds(
                            duration: state.breakTime, isShowText: false)
                        : AppConstant.breakDefaultTime,
                    style: AppTextStyle.appColor16,
                  ),
                  _kSized10,
                  const Divider(height: 0),
                  _kSized10,
                  BlocProvider.value(
                    value: context.read<UserDetailsCubit>(),
                    child: BlocProvider.value(
                      value: context.read<BreakCubit>(),
                      child: BreakInButton.filled(),
                    ),
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
