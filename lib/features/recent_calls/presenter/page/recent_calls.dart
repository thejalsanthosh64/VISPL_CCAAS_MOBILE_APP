import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/search_field.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/recent_calls/cubit/recent_calls_cubit/recent_calls_cubit.dart';
import 'package:kommuno/features/recent_calls/presenter/widget/recent_calls_list.dart';

class RecentCalls extends StatelessWidget {
  const RecentCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentCallsCubit(),
      child: const _RecentCallsState(),
    );
  }
}

class _RecentCallsState extends StatelessWidget {
  const _RecentCallsState();

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  RecentCallsCubit _recentCallsCubit(BuildContext context) =>
      context.read<RecentCallsCubit>();

  @override
  Widget build(BuildContext context) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
      final agentNumber = context.read<UserDetailsCubit>().userDetailsModel.agentMobile;
      final agentId = context.read<UserDetailsCubit>().userDetailsModel.agentId;

    return HideKeyboardWidget(
      child: Scaffold(
        floatingActionButton: const AppShortcutButton(),
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.recentCalls,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(smeId: smeId,agentNumber: agentNumber,agentId:agentId ),
      ),
    );
  }

  Widget _buildBody({required int smeId,required int agentId,required String agentNumber}) {


    
    return BlocBuilder<RecentCallsCubit, RecentCallsState>(
      builder: (context, state) {
        if (state is RecentCallsInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _recentCallsCubit(context).getRecentCalls(smeId: smeId,agentId:agentId);
              }
            },
          );
        } else if (state is RecentCallsLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is RecentCallsErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _recentCallsCubit(context).getRecentCalls(smeId: smeId,agentId: agentId);
            },
          );
        } else if (state is RecentCallsSuccessState) {
          return Column(
            children: [
              /*_kSized10,
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstant.kBodyHorizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CallViewToggleButton(
                  isSelected: false,
                  text: AppLocalizations.of(context)!.incomingCalls,
                  assetName: Assets.iconsIncomingCalls,
                  onTap: () {},
                ),
              ),
              _kSized20,
              Expanded(
                child: CallViewToggleButton(
                  isSelected: true,
                  text: AppLocalizations.of(context)!.outgoingCalls,
                  assetName: Assets.iconsOutgoingCalls,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),*/
              _kSized10,
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.kBodyHorizontalPadding),
                child: AppTextField(
                  hintText: AppLocalizations.of(context)!.selectDate,
                  readOnly: true,
                  controller: _recentCallsCubit(context).dateController,
                  prefixIcon: const Icon(
                    Icons.calendar_month,
                    color: AppColors.appColor,
                  ),
                  onTap: () async {
                    final selectedDate = await appDateRangePicker(
                      context: context,
                      currentDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 90)),
                      lastDate: DateTime.now(),
                    );
                    if (context.mounted && selectedDate != null) {
                      _recentCallsCubit(context).onSelectDate(
                          selectedDate: selectedDate, smeId: smeId,agentNumber: agentNumber,agentId: agentId);
                    }
                  },
                ),
              ),
              _kSized10,
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.kBodyHorizontalPadding),
                child: SearchField(
                  onChanged: (text) {
                    _recentCallsCubit(context).debouncer.run(() {
                      _recentCallsCubit(context).searchRecentCalls(text);
                    });
                  },
                ),
              ),
              _kSized10,
              const Expanded(child: RecentCallsList()),
              _kSized10,
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
