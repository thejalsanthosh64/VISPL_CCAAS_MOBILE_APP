import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_icon_button.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/search_field.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/leads/cubit/lead_cubit/leads_cubit.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_request_model.dart';
import 'package:kommuno/features/leads/presenter/page/filter_leads.dart';
import 'package:kommuno/features/leads/presenter/widget/add_new_lead_button.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_list.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadsCubit(),
      child: const _LeadsScreenState(),
    );
  }
}

class _LeadsScreenState extends StatelessWidget {
  const _LeadsScreenState();

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  LeadsCubit _leadsCubit(BuildContext context) => context.read<LeadsCubit>();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.leads,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(context: context),
        floatingActionButton: const AppShortcutButton(),
      ),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    return BlocConsumer<LeadsCubit, LeadsState>(
      listener: (context, state) {
        if ((state is LeadsSuccessState &&
                state.leadsSourceCityProductStatusData == null) ||
            (state is LeadsFilterState &&
                state.leadsSourceCityProductStatusData == null)) {
          _leadsCubit(context).getSourceCityProductStatus(smeId: smeId);
        }
      },
      builder: (context, state) {
        if (state is LeadsInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _leadsCubit(context).getLeadsUniqueCalls(
                  smeId: smeId,
                  checkFilterApply: true,
                );
              }
            },
          );
        } else if (state is LeadsLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is LeadsErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _leadsCubit(context)
                  .getLeadsUniqueCalls(smeId: smeId, checkFilterApply: true);
            },
          );
        } else if (state is LeadsSuccessState || state is LeadsFilterState) {
          final isExpanded = state is LeadsSuccessState
              ? state.isExpanded
              : state is LeadsFilterState
                  ? state.isExpanded
                  : false;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _kSized10,
              AddNewLeadButton(
                onAddNewLead: (newLeadData) {
                  _leadsCubit(context).getLeadsUniqueCalls(
                      smeId: smeId, isLoading: false, initialRecordValue: 1);
                },
              ),
              if (state is LeadsFilterState ||
                  (state is LeadsSuccessState &&
                      state.leadsUniqueCallsModel.isNotEmpty)) ...[
                _kSized10,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.kBodyHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          onTapOutside: (details) {
                            hideKeyboard();
                          },
                          controller: _leadsCubit(context).leadSearchController,
                          hintText: AppLocalizations.of(context)!.searchLeadDes,
                          onChanged: (text) {
                            _leadsCubit(context).debouncer.run(() {
                              _leadsCubit(context).searchLeadsUniqueCalls(
                                  text: text, smeId: smeId);
                            });
                          },
                        ),
                      ),
                      if ((state is LeadsSuccessState &&
                              state.leadsUniqueCallsModel.isNotEmpty) ||
                          (state is LeadsFilterState &&
                              state.leadsUniqueCallsModel.isNotEmpty)) ...[
                        _kSized10,
                        AppIconButton(
                          icon: isExpanded
                              ? const Icon(CupertinoIcons.rectangle_grid_1x2)
                              : const Icon(Icons.clear_all_rounded),
                          padding: const EdgeInsets.all(2),
                          onTap: () {
                            _leadsCubit(context)
                                .changeExpandedState(!isExpanded);
                          },
                        )
                      ],
                      AppIconButton(
                        icon: const Icon(Icons.filter_list_alt),
                        padding: const EdgeInsets.all(2),
                        onTap: () async {
                          final leadsSourceCityProductStatusData =
                              state is LeadsFilterState
                                  ? state.leadsSourceCityProductStatusData
                                  : state is LeadsSuccessState
                                      ? state.leadsSourceCityProductStatusData
                                      : null;
                          final leadsFilterRequestModel = await appBottomSheet(
                            context: context,
                            child: (ctx) => FilterLeads(
                                leadsSourceCityProductStatusData:
                                    leadsSourceCityProductStatusData),
                            height: MediaQuery.sizeOf(context).height * 0.7,
                          );

                          if (leadsFilterRequestModel != null) {
                            if (context.mounted) {
                              if (leadsFilterRequestModel is List) {
                                final previousFilterDataRequest =
                                    state is LeadsFilterState
                                        ? state.leadsFilterRequestModel
                                        : <LeadsFilterRequestModel>[];

                                if (leadsFilterRequestModel.isEmpty) {
                                  if (previousFilterDataRequest
                                      .map((e) => e.leadFilterEnum)
                                      .contains(LeadFilterEnum.searchLeads)) {
                                    _leadsCubit(context)
                                        .getFilterLeadsUniqueCalls(
                                      smeId: smeId,
                                      leadsFilterRequestModel: [
                                        LeadsFilterRequestModel(
                                            val: _leadsCubit(context)
                                                .leadSearchController
                                                .text,
                                            leadFilterEnum:
                                                LeadFilterEnum.searchLeads),
                                        LeadsFilterRequestModel(
                                          leadFilterEnum:
                                              LeadFilterEnum.agentId,
                                          val:
                                              "${UserLoginInfoManager.userLoginInfoModel!.userId}",
                                        ),
                                      ],
                                      initialRecordValue: 1,
                                    );
                                  } else {
                                    _leadsCubit(context).getLeadsUniqueCalls(
                                        smeId: smeId,
                                        initialRecordValue: 1,
                                        isLoading: false);
                                  }
                                } else {
                                  _leadsCubit(context)
                                      .getFilterLeadsUniqueCalls(
                                    smeId: smeId,
                                    leadsFilterRequestModel: [
                                      if (previousFilterDataRequest
                                          .map((e) => e.leadFilterEnum)
                                          .contains(LeadFilterEnum.searchLeads))
                                        LeadsFilterRequestModel(
                                            val: _leadsCubit(context)
                                                .leadSearchController
                                                .text,
                                            leadFilterEnum:
                                                LeadFilterEnum.searchLeads),
                                      ...leadsFilterRequestModel,
                                    ],
                                    initialRecordValue: 1,
                                  );
                                }
                              }
                            }
                          }
                        },
                      ),
                      if (state is LeadsFilterState &&
                          state.leadsFilterRequestModel.isNotEmpty)
                        InkWell(
                          onTap: () {
                            _leadsCubit(context).getLeadsUniqueCalls(
                                smeId: smeId,
                                isLoading: false,
                                initialRecordValue: 1);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.clearFilter,
                            style: AppTextStyle.appColorNormal,
                          ),
                        )
                    ],
                  ),
                ),
              ],
              _kSized10,
              const Expanded(child: LeadsList()),
              _kSized20,
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
