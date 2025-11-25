// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/widget/app_button.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/common/widget/user_details/user_details_widget.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/campaigns/cubit/campagin_list_cubit/campaign_list_cubit.dart';
import 'package:kommuno/features/campaigns/cubit/update_user_campaign/update_user_campaign_cubit.dart';
import 'package:kommuno/features/campaigns/data/model/request/update_user_campaign_data.dart';
import 'package:kommuno/features/campaigns/presenter/widget/campaign_tile.dart';

class CampaignList extends StatelessWidget {
  const CampaignList({super.key});

  @override
  Widget build(BuildContext context) {
    final isAssignCampaign = ModalRoute.of(context)?.settings.name == AppRouteNames.assignCampaign;
    return PopScope(
      canPop: !isAssignCampaign,
      onPopInvokedWithResult: (didPop, result) async {
        if (isAssignCampaign && !didPop) {
          final isExit = await exitAppDialog(context: context);
          if (isExit) {
            exit(0);
          }
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (__) => CampaignListCubit()),
          BlocProvider(create: (__) => UpdateUserCampaignCubit()),
          if (isAssignCampaign)
            BlocProvider(create: (__) => UserDetailsCubit())
          else
            BlocProvider.value(value: context.read<UserDetailsCubit>())
        ],
        child: _CampaignListState(isAssignCampaign: isAssignCampaign),
      ),
    );
  }
}

class _CampaignListState extends StatelessWidget {
  const _CampaignListState({required this.isAssignCampaign});

  final bool isAssignCampaign;

  void _loadCampaignList({
    required BuildContext context,
  }) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    context.read<CampaignListCubit>().loadCampaigns(smeId: userDetails.smeId);
  }

  SizedBox get _kSized10 => const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 => const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.campaigns,
      ),
      body: SafeArea(
        child: UserDetailsWidget(
          builder: (userData) {
            return BlocListener<UpdateUserCampaignCubit, UpdateUserCampaignState>(
              listener: (context, updateUserCampaignState) {
                if (updateUserCampaignState.isCampaignUpdated) {
                  if (isAssignCampaign) {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRouteNames.homeMiddleware, (settings) => false);
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: BlocConsumer<CampaignListCubit, CampaignListState>(
                listener: (context, campaignListState) {},
                listenWhen: (oldState, currentState) {
                  if (oldState is! CampaignListSuccessState && currentState is CampaignListSuccessState) {
                    if (!isAssignCampaign && currentState.selectedCampaign == null) {
                      context.read<CampaignListCubit>().onSelectCampaign(id: CampaignManager.campaign?.id);
                    }
                  }
                  return false;
                },
                builder: (context, campaignListState) {
                  if (campaignListState is CampaignListInitialState) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        if (context.mounted) {
                          _loadCampaignList(context: context);
                        }
                      },
                    );
                    return const SizedBox();
                  } else if (campaignListState is CampaignListLoadingState) {
                    return const AppLoadingIndicator();
                  } else if (campaignListState is CampaignListErrorState) {
                    return EmptyErrorWidget(
                      text: AppLocalizations.of(context)!.somethingWentWrong,
                      onTap: () {
                        _loadCampaignList(context: context);
                      },
                    );
                  } else if (campaignListState is CampaignListSuccessState) {
                    if (campaignListState.campaignList.isEmpty) {
                      return EmptyErrorWidget(
                        text: AppLocalizations.of(context)!.noRecordFound,
                        onTap: () {
                          _loadCampaignList(context: context);
                        },
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstant.kBodyHorizontalPadding),
                      child: Column(
                        children: [
                          _kSized10,
                          Expanded(
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: campaignListState.campaignList.length,
                              itemBuilder: (context, index) {
                                return CampaignTile(
                                  campaign: campaignListState.campaignList[index],
                                  isSelected: campaignListState.selectedCampaign == campaignListState.campaignList[index].id,
                                  onChanged: (campaign) {
                                    context
                                        .read<CampaignListCubit>()
                                        .onSelectCampaign(id: campaign.id != campaignListState.selectedCampaign ? campaign.id ?? "" : null);
                                  },
                                );
                              },
                            ),
                          ),
                          _kSized10,
                          _updateUserCampaignButton(
                            context: context,
                            campaignListState: campaignListState,
                            userData: userData,
                          ),
                          _kSized5,
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _updateUserCampaignButton({
    required BuildContext context,
    required CampaignListSuccessState campaignListState,
    required UserDetailsModel userData,
  }) {
    final campaign = campaignListState.campaignList.firstWhereOrNull((e) => e.id == campaignListState.selectedCampaign);
    return AppButton(
      text: AppLocalizations.of(context)!.update,
      onTap: campaign != null && CampaignManager.campaign?.id != campaign.id
          ? () {
              final queueId = campaign.campaignQueue != null ? int.tryParse(campaign.campaignQueue ?? "0") : null;
              context.read<UpdateUserCampaignCubit>().updateUserCampaign(
                    updateCampaignData: UpdateUserCampaignData(
                      // smeId: userData.smeId,
                      // agentName: userData.agentName,
                      // queueId: queueId,
                      // selectedCampaigns: [
                      //   SelectedCampaign(
                      //     queueId: queueId,
                      //     campaignId: campaign.id,
                      //     campaignName: campaign.campaignName,

 agentId: userData.agentId,
    agentName: userData.agentName,
    queueId: campaign.campaignQueue ?? "0",
    selectedCampaigns: [
      SelectedCampaignItem(
        itemText: campaign.campaignName ?? "",
        name: campaign.campaignName ?? "",
        itemId: campaign.id ?? "",
        id: campaign.id ?? "",
        category: campaign.campaignType??"",
        group: campaign.campaignType??"",
        queueId: campaign.campaignQueue ?? "0",
      )
    ],

                      //   )
                      // ],
                    ),
                    campaignData: campaign,
                  );
            }
          : null,
    );
  }
}
