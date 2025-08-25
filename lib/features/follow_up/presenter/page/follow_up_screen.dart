import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/search_field.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/follow_up/cubit/follow_up_cubit.dart';
import 'package:kommuno/features/follow_up/presenter/widget/add_new_follow_up_button.dart';
import 'package:kommuno/features/follow_up/presenter/widget/follow_up_list_tile.dart';

class FollowUpScreen extends StatelessWidget {
  const FollowUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUpCubit(
          smeId: context.read<UserDetailsCubit>().userDetailsModel.smeId),
      child: const _FollowUpState(),
    );
  }
}

class _FollowUpState extends StatelessWidget {
  const _FollowUpState();

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  FollowUpCubit _followUpCubit(BuildContext context) =>
      context.read<FollowUpCubit>();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        floatingActionButton: const AppShortcutButton(),
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.followUp,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FollowUpCubit, FollowUpState>(
      builder: (context, state) {
        if (state is FollowUpInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _followUpCubit(context).getFollowUpDetails();
              }
            },
          );
        } else if (state is FollowUpLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is FollowUpErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _followUpCubit(context).getFollowUpDetails();
            },
          );
        } else if (state is FollowUpSuccessState) {
          return Column(
            children: [
              _kSized15,
              AddNewFollowUpButton(
                onAddNewFollowup: (details) {
                  _followUpCubit(context).getFollowUpDetails(
                      isLoading: false, initialRecordValue: 1);
                },
              ),
              if (state.followUpListModel.isNotEmpty) ...[
                _kSized15,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.kBodyHorizontalPadding),
                  child: SearchField(
                    controller: _followUpCubit(context).searchController,
                    onChanged: (text) {
                      _followUpCubit(context).debouncer.run(() {
                        _followUpCubit(context).searchFollowUp(text);
                      });
                    },
                  ),
                ),
              ],
              _kSized15,
              Expanded(child: _buildList(context: context, state: state)),
              _kSized15,
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildList(
      {required BuildContext context, required FollowUpSuccessState state}) {
    final followUpList = state.searchedFollowUpListModel == null
        ? state.followUpListModel
        : state.searchedFollowUpListModel!;

    if (followUpList.isEmpty) {
      return EmptyErrorWidget(
        showButton: state.searchedFollowUpListModel == null,
        text: AppLocalizations.of(context)!.noRecordFound,
        onTap: () {
          _followUpCubit(context).getFollowUpDetails();
        },
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          _followUpCubit(context)
              .getFollowUpDetails(isLoading: false, initialRecordValue: 1);
        },
        child: ListView.builder(
          controller: _followUpCubit(context)
              .paginationScrollController
              .scrollController,
          physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: followUpList.length,
          itemBuilder: (__, index) {
            return FollowUpListTile(
              key: ValueKey<String>(
                  "FollowUpScreen_FollowUpList_$index${followUpList[index].id}"),
              followUpDetail: followUpList[index],
              index: index,
              onPressPendingButton: (followUpDetail) {
                _followUpCubit(context)
                    .changeScheduleStatus(scheduleId: followUpList[index].id);
              },
            );
          },
        ),
      );
    }
  }
}
