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
import 'package:kommuno/features/assigned_calls/cubit/assigned_calls_cubit.dart';
import 'package:kommuno/features/assigned_calls/presenter/widget/assigned_calls_list.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';

class AssignedCallsScreen extends StatelessWidget {
  const AssignedCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (__) => AssignedCallsCubit(),
      child: const _AssignedCallsState(),
    );
  }
}

class _AssignedCallsState extends StatelessWidget {
  const _AssignedCallsState();

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  AssignedCallsCubit _assignedCallsCubit(BuildContext context) =>
      context.read<AssignedCallsCubit>();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        floatingActionButton: const AppShortcutButton(),
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.assignedCalls,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(context: context),
      ),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<AssignedCallsCubit, AssignedCallsState>(
      builder: (context, state) {
        if (state is AssignedCallsInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _assignedCallsCubit(context).getAssignedCalls(
                    smeId: context
                        .read<UserDetailsCubit>()
                        .userDetailsModel
                        .smeId);
              }
            },
          );
        } else if (state is AssignedCallsLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is AssignedCallsErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _assignedCallsCubit(context).getAssignedCalls(
                  smeId:
                      context.read<UserDetailsCubit>().userDetailsModel.smeId);
            },
          );
        } else if (state is AssignedCallsSuccessState) {
          return Column(
            children: [
              _kSized15,
              if (state.assignedCallsDetails.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.kBodyHorizontalPadding),
                  child: SearchField(
                    onChanged: (text) {
                      _assignedCallsCubit(context).debouncer.run(() {
                        _assignedCallsCubit(context).searchAssignedCalls(text);
                      });
                    },
                  ),
                ),
              _kSized15,
              const Expanded(child: AssignedCallsList()),
              _kSized15,
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
