import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';
import 'package:kommuno/core/common/widget/bottom_sheet_header.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/features/leads/cubit/edit_lead_cubit/edit_lead_cubit.dart';
import 'package:kommuno/features/leads/data/model/request/edit_lead_request_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/features/leads/data/model/response/leads_unique_calls_model.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_dropdown.dart';

class EditLeadScreen extends StatelessWidget {
  const EditLeadScreen({
    super.key,
    this.leadsSourceCityProductStatusData,
    required this.leadsUniqueCall,
  });

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;
  final LeadsUniqueCallsModel leadsUniqueCall;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditLeadCubit(),
      child: _EditLeadScreenState(
        leadsSourceCityProductStatusData: leadsSourceCityProductStatusData,
        leadsUniqueCall: leadsUniqueCall,
      ),
    );
  }
}

class _EditLeadScreenState extends StatelessWidget {
  const _EditLeadScreenState({
    this.leadsSourceCityProductStatusData,
    required this.leadsUniqueCall,
  });

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  final LeadsUniqueCallsModel leadsUniqueCall;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  EditLeadCubit _editLeadCubit(BuildContext context) =>
      context.read<EditLeadCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Column(
        children: [
          BottomSheetHeader(title: AppLocalizations.of(context)!.leadEdit),
          Expanded(
            child: BlocListener<EditLeadCubit, EditLeadState>(
              listenWhen: (previousState, newState) {
                if (previousState is! EditLeadSuccessState &&
                    newState is EditLeadSuccessState) {
                  return true;
                }
                return false;
              },
              listener: (context, state) {
                if (state is EditLeadSuccessState) {
                  _editLeadCubit(context)
                      .initData(leadsUniqueCall: leadsUniqueCall);
                }
              },
              child: BlocConsumer<EditLeadCubit, EditLeadState>(
                listener: (context, state) {
                  if (state is EditLeadSuccessState) {
                    if (state.editLeadRequestData != null) {
                      Navigator.of(context).pop(state.editLeadRequestData);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is EditLeadInitialState) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        if (context.mounted) {
                          _editLeadCubit(context).getSourceCityProductStatus(
                              smeId: smeId,
                              leadsSourceCityProductStatusData:
                                  leadsSourceCityProductStatusData);
                        }
                      },
                    );
                  } else if (state is EditLeadLoadingState) {
                    return const AppLoadingIndicator(color: AppColors.white);
                  } else if (state is EditLeadErrorState) {
                    return EmptyErrorWidget(
                      isOutlined: true,
                      text: AppLocalizations.of(context)!.somethingWentWrong,
                      style: AppTextStyle.white18,
                      onTap: () {
                        _editLeadCubit(context).getSourceCityProductStatus(
                            smeId: smeId,
                            leadsSourceCityProductStatusData:
                                leadsSourceCityProductStatusData);
                      },
                    );
                  } else if (state is EditLeadSuccessState) {
                    return Column(
                      children: [
                        _kSized10,
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LeadsDropdown<LeadStatus>(
                                  title: AppLocalizations.of(context)!.status,
                                  value: state.selectLeadStatus,
                                  onChanged: (selectLeadStatus) {
                                    _editLeadCubit(context).selectLeadStatus(
                                        selectLeadStatus: selectLeadStatus!);
                                  },
                                  items: state.leadsSourceCityProductStatusData
                                      .leadStatus,
                                  onBuildText: (value) {
                                    return value.leadStatus;
                                  },
                                  onBuildValue: (value) {
                                    return value;
                                  },
                                ),
                                _kSized10,
                                LeadsDropdown<LeadSource>(
                                  title: AppLocalizations.of(context)!.source,
                                  value: state.selectLeadSource,
                                  onChanged: (selectLeadSource) {
                                    _editLeadCubit(context).selectLeadSource(
                                        selectLeadSource: selectLeadSource!);
                                  },
                                  items: state.leadsSourceCityProductStatusData
                                      .leadSource,
                                  onBuildText: (value) {
                                    return value.source;
                                  },
                                  onBuildValue: (value) {
                                    return value;
                                  },
                                ),
                                _kSized10,
                                LeadsDropdown<LeadCity>(
                                  title: AppLocalizations.of(context)!.city,
                                  value: state.selectLeadsCity,
                                  onChanged: (selectLeadsCity) {
                                    _editLeadCubit(context).selectLeadsCity(
                                        selectLeadsCity: selectLeadsCity!);
                                  },
                                  items: state
                                      .leadsSourceCityProductStatusData.cities,
                                  onBuildText: (value) {
                                    return value.cityName;
                                  },
                                  onBuildValue: (value) {
                                    return value;
                                  },
                                ),
                                _kSized10,
                                LeadsDropdown<LeadProduct>(
                                  title: AppLocalizations.of(context)!.product,
                                  value: state.selectLeadsProduct,
                                  onChanged: (selectLeadsProduct) {
                                    _editLeadCubit(context).selectLeadsProduct(
                                        selectLeadsProduct:
                                            selectLeadsProduct!);
                                  },
                                  items: state.leadsSourceCityProductStatusData
                                      .products,
                                  onBuildText: (value) {
                                    return value.productName ?? '';
                                  },
                                  onBuildValue: (value) {
                                    return value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        _kSized20,
                        AppOutlineButton(
                          text: AppLocalizations.of(context)!.save,
                          onTap: () {
                            _editLeadCubit(context).updateUniqueCalls(
                              smeId: smeId,
                              editLeadRequestData: EditLeadRequestData(
                                addressBookId: leadsUniqueCall.addressBookId,
                                agentNumber: leadsUniqueCall.agentMobile,
                                cityId: state.selectLeadsCity?.cityId,
                                id: leadsUniqueCall.id,
                                leadAssignedAgent:
                                    leadsUniqueCall.assignedAgentId,
                                recentPatchedAgentId:
                                    leadsUniqueCall.recentPatchedAgentId,
                                leadSource: state.selectLeadSource?.id,
                                leadStatus: state.selectLeadStatus?.id,
                                productId: state.selectLeadsProduct?.id,
                                sourceId: state.selectLeadSource?.id,
                                customerName: leadsUniqueCall.customerName,
                                companyName: leadsUniqueCall.companyName,
                                emailId: leadsUniqueCall.emailId,
                                customerNumber: leadsUniqueCall.customerNumber,
                                customerNumberPrimary:
                                    leadsUniqueCall.customerNumber,
                                insertDateTime: DateTime.now(),
                                leadType: null,
                                productPrice: null,
                              ),
                            );
                          },
                        ),
                        _kSized10,
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
