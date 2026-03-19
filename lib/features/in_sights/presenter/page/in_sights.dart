import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/custom_field_deoration.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/in_sights/cubit/in_sights_cubit/in_sights_cubit.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/in_sights/data/enum/in_sights_date_enum.dart';
import 'package:kommuno/features/in_sights/data/model/response/disposition_summary_response.dart';
import 'package:kommuno/features/in_sights/data/model/response/in_sights_response.dart';
import 'package:kommuno/features/in_sights/presenter/widget/calls_info_container.dart';
import 'package:kommuno/features/in_sights/presenter/widget/days_chip.dart';
import 'package:kommuno/features/in_sights/presenter/widget/duration_info_container.dart';

class InSightsScreen extends StatelessWidget {
  const InSightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InSightsCubit(),
      child: const _InSightsState(),
    );
  }
}

class _InSightsState extends StatelessWidget {
  const _InSightsState();

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  InSightsCubit _inSightsCubit(BuildContext context) =>
      context.read<InSightsCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppShortcutButton(),
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.insights,
        actions: [BreakInButton.outline()],
      ),
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kSized10,
          _buildUserDetails(userDetails: userDetails),
          _kSized10,
          Expanded(child: _buildInsightsDetails(userDetails: userDetails)),
          _kSized10,
          
        ],
      ),
    );
  }

  Widget _buildUserDetails({required UserDetailsModel userDetails}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAvatar(
          child: Text(userDetails.agentName.capitalizeFirstLetterOfTwoWords,
              style: AppTextStyle.whiteNormal),
        ),
        const SizedBox(width: AppConstant.kSized15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(userDetails.agentName, style: AppTextStyle.appColorNormal),
            Text(
                addByIndiaCountryCodeWithoutPlus(
                    number: userDetails.agentMobile),
                style: AppTextStyle.appColorNormal),
          ],
        )
      ],
    );
  }

  Widget _buildInsightsDetails({required UserDetailsModel userDetails}) {
    return BlocBuilder<InSightsCubit, InSightsState>(
      builder: (context, state) {
        if (state is InSightsInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _inSightsCubit(context).getInSights(
                  smeId: userDetails.smeId,
                  isLoading: true,
                  inSightsDateEnum: InSightsDateEnum.today,
                );
              }
            },
          );
        } else if (state is InSightsLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is InSightsErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _inSightsCubit(context).getInSights(
                smeId: userDetails.smeId,
                isLoading: true,
                inSightsDateEnum: InSightsDateEnum.today,
              );
            },
          );
        } else if (state is InSightsSuccessState) {
          return RefreshIndicator(
            onRefresh: () async {
              _inSightsCubit(context).getInSights(
                smeId: userDetails.smeId,
                inSightsDateEnum: state.inSightsDateEnum,
                selectedDateTimeRange: state.dateTimeRange,
              );
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDaysChip(
                      context: context, userDetails: userDetails, state: state),
                  _kSized10,
                  CustomFieldDecoration(
                    suffixIcon: const [Icon(Icons.calendar_month)],
                    value: state.dateTimeRange != null
                        ? "${DateUtility.getDateYMDOnly(date: state.dateTimeRange!.start)}    ${DateUtility.getDateYMDOnly(date: state.dateTimeRange!.end)}"
                        : null,
                    hinText: AppLocalizations.of(context)!.selectDateTime,
                    style: AppTextStyle.appColorNormal,
                    // onTap: () async {
                    //   final dateRange = await appDateRangePicker(
                    //     context: context,
                    //     currentDate: DateTime.now(),
                    //     firstDate:
                    //         DateTime.now().subtract(const Duration(days: 90)),
                    //     lastDate: DateTime.now(),
                    //   );
                    //   if (context.mounted && dateRange != null) {
                    //     _inSightsCubit(context).getInSights(
                    //         smeId: userDetails.smeId,
                    //         selectedDateTimeRange: dateRange);
                    //   }
                    // },
    //                 onTap: () => DateUtility.selectDateRangeWithLimit(
    // context: context,
    // maxDays: 31, // Your specific limit for this screen
    // onSelected: (dateRange) {
    //   _inSightsCubit(context).getInSights(
    //     smeId: userDetails.smeId,
    //     selectedDateTimeRange: dateRange,
    //   );
    // },)

    onTap: () => DateUtility.selectDateRangeWithLimit(
    context: context,
    maxDays: 31, // Your specific limit for this screen
    onSelected: (dateRange) {
      _inSightsCubit(context).getInSights(
        smeId: userDetails.smeId,
        selectedDateTimeRange: dateRange,
      );
    },)
                  ),
                  _kSized10,
                  ..._buildCallsInfo(
                    context: context,
                    title: AppLocalizations.of(context)!.incomingCalls,
                    totalValue: state.insightsResponse.totalInCalls,
                    failValue: state.insightsResponse.inFailedCalls,
                    successValue: state.insightsResponse.inSuccessCalls,
                    successPercentAge: double.tryParse(
                        state.insightsResponse.inSuccess?.toStringAsFixed(2) ??
                            ''),
                  ),
                  _kSized20,
                  const Divider(height: 0),
                  _kSized5,
                  ..._buildCallsInfo(
                    context: context,
                    title: AppLocalizations.of(context)!.outgoingCalls,
                    totalValue: state.insightsResponse.totalOutCalls,
                    failValue: state.insightsResponse.outFailedCalls,
                    successValue: state.insightsResponse.outSuccessCalls,
                    successPercentAge: double.tryParse(
                        state.insightsResponse.outSuccess?.toStringAsFixed(2) ??
                            ''),
                  ),
                  _kSized20,
                  _buildDuration(context: context, state: state),
_kSized20,
                  _buildAgentStatusSummary(state.insightsResponse, context),
                  _kSized20,
                    _buildDispositionSummary(context,state.dispositionSummary),
                                      _kSized20,


                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildDaysChip(
      {required BuildContext context,
      required UserDetailsModel userDetails,
      required InSightsSuccessState state}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          InSightsDateEnum.values.length,
          (index) {
            return DaysChip(
              isSelected:
                  state.inSightsDateEnum == InSightsDateEnum.values[index],
              text: _getChipText(
                  inSightsDateEnum: InSightsDateEnum.values[index],
                  context: context),
              onTap: () {
                _inSightsCubit(context).getInSights(
                    smeId: userDetails.smeId,
                    inSightsDateEnum: InSightsDateEnum.values[index]);
              },
            );
          },
        ),
      ),
    );
  }

  String _getChipText(
      {required InSightsDateEnum inSightsDateEnum,
      required BuildContext context}) {
    switch (inSightsDateEnum) {
      case InSightsDateEnum.today:
        return AppLocalizations.of(context)!.today;
      case InSightsDateEnum.yesterday:
        return AppLocalizations.of(context)!.yesterday;
      case InSightsDateEnum.last7Days:
        return AppLocalizations.of(context)!.last7Days;
      case InSightsDateEnum.last15Days:
        return AppLocalizations.of(context)!.last15Days;
      case InSightsDateEnum.last30Days:
        return AppLocalizations.of(context)!.last30Days;
    }
  }

  List<Widget> _buildCallsInfo({
    required BuildContext context,
    required String title,
    int? totalValue,
    int? successValue,
    int? failValue,
    double? successPercentAge,
  }) {
    return [
      Text(
        title,
        style: AppTextStyle.black18,
      ),
      _kSized10,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              child: CallsInfoContainer(
                color: AppColors.appColor,
                title: AppLocalizations.of(context)!.totalCalls,
                count: totalValue,
              ),
            ),
          ),
          _kSized5,
          Flexible(
            child: FittedBox(
              child: CallsInfoContainer(
                title: AppLocalizations.of(context)!.success,
                count: successValue,
              ),
            ),
          ),
          _kSized5,
          Flexible(
            child: FittedBox(
              child: CallsInfoContainer(
                title: AppLocalizations.of(context)!.fail,
                count: failValue,
              ),
            ),
          ),
          _kSized5,
          Flexible(
            child: FittedBox(
              child: CallsInfoContainer(
                title: AppLocalizations.of(context)!.successPercent,
                count: successPercentAge,
              ),
            ),
          )
        ],
      ),
      
    ];
  }
//   int _calculateWaitingTime(InsightsResponse data) {
//   final ringing = data.totalRingingDuration ?? 0;
//   final connected = data.totalConnectedDuration ?? 0;
//   final wrapUp = data.wrapUpTime ?? 0;
//   final breakTime = data.lunchHours ?? 0;
//   final hold = data.holdTime ?? 0;

//   // Waiting / Active Time calculation as per client logic
//   return ringing + connected + wrapUp + breakTime + hold;
// }

Widget _buildAgentStatusSummary(InsightsResponse data,BuildContext context) {
  // final int waitingTime = _calculateWaitingTime(data);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      const SizedBox(height: 10),

      const Text(
        "Agent Status Summary",
        style: AppTextStyle.black18,
      ),

      const SizedBox(height: 12),

      Wrap(
        alignment: WrapAlignment.center,
        spacing: AppConstant.kSized5,
        runSpacing: AppConstant.kSized10,
        children: [
          _statusCircle(
            context,
            "On Call",
             data.totalCallDuration,
          ),
          _statusCircle(
                        context,

       "On Wrapup",
            data.wrapUpTime,
          ),
          _statusCircle(
                        context,

           "Ringing",
             data.totalRingingDuration,
          ),
          _statusCircle(
                        context,

            "On Hold",
            data.holdTime,
          ),
          _statusCircle(
                        context,

          "Break Time",
          data.lunchHours,
          ),
          _statusCircle(
                        context,

          "Talk Time",
            data.talkTime,
          ),
          _statusCircle(
                        context,

            "Waiting",
            data.waitingTime,
          ),
        ],
      ),
    ],
  );
}
// Widget _statusCircle({
//   required String title,
//   int? seconds,
//   bool isPrimary = false,
// }) {
  
//   return FittedBox(
//     child: DurationInfoContainer(
//       title: title,
//       count: seconds,
//       color: isPrimary ? AppColors.appColor : null,
//     ),
//   );
// }
Widget _statusCircle(
  BuildContext context,
  String title,
  int? seconds,
) {
  final double width =
      (MediaQuery.of(context).size.width -
              (AppConstant.kBodyHorizontalPadding * 2) -
              (AppConstant.kSized5 * 3)) /
          4;

  return SizedBox(
    width: width,
    child: DurationInfoContainer(
      title: title,
      count: seconds,
    ),
  );
}


// Widget _buildDispositionSummary(
//     DispositionSummaryResponse dispositionSummary) {
//   if (dispositionSummary.items.isEmpty) {
//     return const SizedBox();
//   }

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Divider(),
//       const SizedBox(height: 10),

//       const Text(
//         "Disposition Summary",
//         style: AppTextStyle.black18,
//       ),

//       const SizedBox(height: 10),

//       Wrap(
//         alignment: WrapAlignment.center,
//         spacing: AppConstant.kSized5,
//         runSpacing: AppConstant.kSized10,
//         children: dispositionSummary.items.map((item) {
//           return FittedBox(
//             child: CallsInfoContainer(
//               title: item.name,
//               count: item.count,
//             ),
//           );
//         }).toList(),
//       ),
//     ],
//   );
// }
// Widget _buildDispositionSummary(
//   BuildContext context,
//   DispositionSummaryResponse dispositionSummary,
// ) {
//   if (dispositionSummary.items.isEmpty) {
//     return const SizedBox();
//   }

//   final double itemWidth =
//       (MediaQuery.of(context).size.width -
//               (AppConstant.kBodyHorizontalPadding * 2) -
//               (AppConstant.kSized5 * 3)) /
//           4;

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Divider(),
//       const SizedBox(height: 10),
//       const Text(
//         "Disposition Summary",
//         style: AppTextStyle.black18,
//       ),
//       const SizedBox(height: 10),
//       Wrap(
//         spacing: AppConstant.kSized5,
//         runSpacing: AppConstant.kSized10,
//         children: dispositionSummary.items.map((item) {
//           return SizedBox(
//             width: itemWidth,
//             child: CallsInfoContainer(
//               title: item.name,
//               count: item.count,
//             ),
//           );
//         }).toList(),
//       ),
//     ],
//   );
// }

// Widget _buildDispositionSummary(
//     BuildContext context,
//     DispositionSummaryResponse dispositionSummary,
//   ) {
//     if (dispositionSummary.items.isEmpty) {
//       return const SizedBox();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Divider(),
//         const SizedBox(height: 10),
//         const Text(
//           "Disposition Summary",
//           style: AppTextStyle.black18,
//         ),
//         const SizedBox(height: 12),
        
//         // Vertical list replaces the Wrap grid
//         Column(
//           children: dispositionSummary.items.map((item) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.appColor.withOpacity(0.4)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.02),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   // Left side: Disposition Name (Expanded allows it to wrap nicely)
//                   Expanded(
//                     child: Text(
//                       item.name ?? "Unknown",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
                  
//                   // Right side: Count Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: AppColors.appColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "${item.count ?? 0}",
//                       style: const TextStyle(
//                         color: AppColors.appColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

// Widget _buildDispositionSummary(
//     BuildContext context,
//     DispositionSummaryResponse dispositionSummary,
//   ) {
//     if (dispositionSummary.items.isEmpty) {
//       return const SizedBox();
//     }

//     // Perfectly calculate the width for 4 items per row
//     final double itemWidth = (MediaQuery.of(context).size.width -
//             (AppConstant.kBodyHorizontalPadding * 2) -
//             (AppConstant.kSized5 * 3)) /
//         4;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Divider(),
//         const SizedBox(height: 10),
//         const Text(
//           "Disposition Summary",
//           style: AppTextStyle.black18,
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: AppConstant.kSized5,
//           runSpacing: AppConstant.kSized10,
//           children: dispositionSummary.items.map((item) {
            
//             return Tooltip(
//               message: item.name ?? "", // Allows user to long-press to see the full name if it gets cut off
//               child: Container(
//                 width: itemWidth,
//                 height: 85, // 👈 Force uniform height for every box
//                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: AppColors.appColor),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Text section expands to push the number to the bottom nicely
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           item.name ?? "",
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                           style: AppTextStyle.appColorNormal.copyWith(
//                             fontSize: 11, // Slightly smaller to fit long names better
//                             height: 1.1,  // Tighter line height for 2-line texts
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     // The count number
//                     Text(
//                       "${item.count ?? 0}",
//                       style: AppTextStyle.appColor23.copyWith(
//                         fontSize: 18, // Scaled down slightly to balance the box
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
            
//           }).toList(),
//         ),
//       ],
//     );
//   }


Widget _buildDispositionSummary(
    BuildContext context,
    DispositionSummaryResponse dispositionSummary,
  ) {
    if (dispositionSummary.items.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      // Adds a nice gap between the top section and the bottom of the screen
      padding: const EdgeInsets.only(top: 10, bottom: 20), 
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Tighter outer padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.appColor.withOpacity(0.2)), // Soft purple border
          boxShadow: [
            BoxShadow(
              color: AppColors.appColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Disposition Summary",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.appColor,
              ),
            ),
            const SizedBox(height: 16), // Tighter gap below the title

            Column(
              children: dispositionSummary.items.map((item) {
                final String rawName = item.name ?? "Unknown";
                // Added a space after the arrow for better readability
                final String formattedPath = "${rawName.replaceAll(',', ' → ')}:";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8), // Tighter gap between rows
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          formattedPath,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.3, // Tighter line height
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${item.count ?? 0}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500, // Slightly less bold, like the mockup
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuration(
      {required BuildContext context, required InSightsSuccessState state}) {

        final insights = state.insightsResponse;
final int calculatedActiveTime = (insights.waitingTime ?? 0) +
        (insights.wrapUpTime ?? 0) +
        (insights.totalRingingDuration ?? 0) +
        (insights.totalConnectedDuration ?? 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: FittedBox(
            child: DurationInfoContainer(
              title: AppLocalizations.of(context)!.totalCallDuration,
              color: AppColors.appColor,
              count: state.insightsResponse.totalCallDuration,
            ),
          ),
        ),
        _kSized5,
        Flexible(
          child: FittedBox(
            child: DurationInfoContainer(
              title: AppLocalizations.of(context)!.avgCallDuration,
              count: state.insightsResponse.avgCallDuration,
            ),
          ),
        ),
        _kSized5,
        Flexible(
          child: FittedBox(
            child: DurationInfoContainer(
              title: AppLocalizations.of(context)!.totalActiveTime,
              count: calculatedActiveTime,
            ),
          ),
        ),
        _kSized5,
        Flexible(
          child: FittedBox(
            child: DurationInfoContainer(
              title: AppLocalizations.of(context)!.totalBreakTime,
              count: state.insightsResponse.lunchHours,
            ),
          ),
        ),
      ],
    );
  }
}
