import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/search_field.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/follow_up/cubit/follow_up_cubit.dart';
import 'package:kommuno/features/follow_up/presenter/widget/add_new_follow_up_button.dart';
import 'package:kommuno/features/follow_up/presenter/widget/follow_up_list_tile.dart';

// class FollowUpScreen extends StatelessWidget {
//   const FollowUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FollowUpCubit(
//           smeId: context.read<UserDetailsCubit>().userDetailsModel.smeId),
//       child: const _FollowUpState(),
//     );
//   }
// }

// class _FollowUpState extends StatelessWidget {
//   const _FollowUpState();

//   SizedBox get _kSized15 =>
//       const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

//   FollowUpCubit _followUpCubit(BuildContext context) =>
//       context.read<FollowUpCubit>();

//   @override
//   Widget build(BuildContext context) {
//     return HideKeyboardWidget(
//       child: Scaffold(
//         floatingActionButton: const AppShortcutButton(),
//         appBar: MyAppBar(
//           title: AppLocalizations.of(context)!.followUp,
//           actions: [BreakInButton.outline()],
//         ),
//         body: _buildBody(),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return BlocBuilder<FollowUpCubit, FollowUpState>(
//       builder: (context, state) {
//         if (state is FollowUpInitialState) {
//           Future.delayed(
//             Duration.zero,
//             () {
//               if (context.mounted) {
//                 _followUpCubit(context).getFollowUpDetails();
//               }
//             },
//           );
//         } else if (state is FollowUpLoadingState) {
//           return const AppLoadingIndicator();
//         } else if (state is FollowUpErrorState) {
//           return EmptyErrorWidget(
//             text: AppLocalizations.of(context)!.somethingWentWrong,
//             onTap: () {
//               _followUpCubit(context).getFollowUpDetails();
//             },
//           );
//         } else if (state is FollowUpSuccessState) {
//           return Column(
//             children: [
//               _kSized15,
//               AddNewFollowUpButton(
//                 onAddNewFollowup: (details) {
//                   _followUpCubit(context).getFollowUpDetails(
//                       isLoading: false, initialRecordValue: 1);
//                 },
//               ),
//               if (state.followUpListModel.isNotEmpty) ...[
//                 _kSized15,
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: AppConstant.kBodyHorizontalPadding),
//                   child: SearchField(
//                     controller: _followUpCubit(context).searchController,
//                     onChanged: (text) {
//                       _followUpCubit(context).debouncer.run(() {
//                         _followUpCubit(context).searchFollowUp(text);
//                       });
//                     },
//                   ),
//                 ),
//               ],
//               _kSized15,
//               Expanded(child: _buildList(context: context, state: state)),
//               _kSized15,
//             ],
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildList(
//       {required BuildContext context, required FollowUpSuccessState state}) {
//     final followUpList = state.searchedFollowUpListModel == null
//         ? state.followUpListModel
//         : state.searchedFollowUpListModel!;

//     if (followUpList.isEmpty) {
//       return EmptyErrorWidget(
//         showButton: state.searchedFollowUpListModel == null,
//         text: AppLocalizations.of(context)!.noRecordFound,
//         onTap: () {
//           _followUpCubit(context).getFollowUpDetails();
//         },
//       );
//     } else {
//       return RefreshIndicator(
//         onRefresh: () async {
//           _followUpCubit(context)
//               .getFollowUpDetails(isLoading: false, initialRecordValue: 1);
//         },
//         child: ListView.builder(
//           controller: _followUpCubit(context)
//               .paginationScrollController
//               .scrollController,
//           physics: const ClampingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics()),
//           itemCount: followUpList.length,
//           itemBuilder: (__, index) {
//             return FollowUpListTile(
//               key: ValueKey<String>(
//                   "FollowUpScreen_FollowUpList_$index${followUpList[index].id}"),
//               followUpDetail: followUpList[index],
//               index: index,
//               onPressPendingButton: (followUpDetail) {
//                 _followUpCubit(context)
//                     .changeScheduleStatus(scheduleId: followUpList[index].id);
//               },
//             );
//           },
//         ),
//       );
//     }
//   }
// }


class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUpCubit(
        agentId: context.read<UserDetailsCubit>().userDetailsModel.agentId,
        smeId: context.read<UserDetailsCubit>().userDetailsModel.smeId,
      ),
      child: const _FollowUpState(),
    );
  }
}

class _FollowUpState extends StatelessWidget {
  const _FollowUpState();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowUpCubit>();

    return HideKeyboardWidget(
      child: Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.followUp,
          actions: [BreakInButton.outline()],
        ),
        floatingActionButton: const AppShortcutButton(),
        body: Column(
          children: [
            const SizedBox(height: 15),

            _buildTabs(context),

            const SizedBox(height: 15),

            BlocBuilder<FollowUpCubit, FollowUpState>(
              builder: (context, state) {
                return Visibility(
                  visible: cubit.selectedTab != FollowUpTab.past,
                  child: AddNewFollowUpButton(
                    onAddNewFollowup: (_) {
                      cubit.refreshCurrentTab();
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                controller: cubit.searchController,
                onChanged: (text) {
                  cubit.debouncer.run(() {
                    cubit.searchFollowUp(text);
                  });
                },
              ),
            ),

            const SizedBox(height: 15),

           Expanded(
  child: BlocBuilder<FollowUpCubit, FollowUpState>(
    builder: (context, state) {
      if (state is FollowUpInitialState) {
        return const Center(child: AppLoadingIndicator());
      }
      
      if (state is FollowUpLoadingState) {
        return const Center(child: AppLoadingIndicator());
      }

      if (state is FollowUpErrorState) {
        return EmptyErrorWidget(
          text: AppLocalizations.of(context)!.somethingWentWrong,
          onTap: () => cubit.refreshCurrentTab(),
        );
      }

      if (state is FollowUpSuccessState) {
        return _buildList(context, cubit, state);
      }

      return const SizedBox();
    },
  ),
)
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final cubit = context.read<FollowUpCubit>();

    return BlocBuilder<FollowUpCubit, FollowUpState>(
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _tabButton(context, AppLocalizations.of(context)!.past, FollowUpTab.past),
_tabButton(context, AppLocalizations.of(context)!.today, FollowUpTab.today),
_tabButton(context, AppLocalizations.of(context)!.upcoming, FollowUpTab.upcoming),

          ],
        );
      },
    );
  }

  Widget _tabButton(BuildContext context, String label, FollowUpTab tab) {
    final cubit = context.read<FollowUpCubit>();
    final isSelected = cubit.selectedTab == tab;

    return GestureDetector(
      onTap: () => cubit.changeTab(tab),
      child: Container(
        alignment: Alignment.center, 
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : AppColors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.appColor),
        ),
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: isSelected
              ? AppTextStyle.whiteNormal
              : AppTextStyle.appColorNormal,
        ),
      ),
    );
  }

Future<bool?> _showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(
          AppLocalizations.of(context)!.areYouSure,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content:  Text(
          AppLocalizations.of(context)!.confirmMessage, 
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child:  Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      );
    },
  );
}
  Widget _buildList(BuildContext context, FollowUpCubit cubit, FollowUpSuccessState state) {
  final list = state.searchedFollowUpListModel ?? cubit.getCurrentList();

  if (list.isEmpty) {
    return EmptyErrorWidget(
     text: state.searchedFollowUpListModel != null
    ? AppLocalizations.of(context)!.noMatchingRecordsFound
    : AppLocalizations.of(context)!.noRecordsFound,
         
      showButton: true,
      onTap: () => cubit.refreshCurrentTab(),
    );
  }

  return RefreshIndicator(
    onRefresh: () => cubit.refreshCurrentTab(),
    child: ListView.builder(
      controller: cubit.paginationScrollController.scrollController,
      itemCount: list.length,
      itemBuilder: (_, index) {
        final item = list[index];
final userDetails = context.read<UserDetailsCubit>().userDetailsModel;

        return FollowUpListTile(
          followUpDetail: item,
          index: index,
          onPressPendingButton: (d) {
            cubit.markAsCompleted(d.id);
          },
          showDeleteDialog: _showDeleteDialog,
          onPressDelete: (followUpDetail) {
    cubit.deleteFollowUp(followUpDetail, userDetails);
  },
        );
      },
    ),
  );
}
}
