// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/app_radio_tile.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/common/widget/bottom_sheet_header.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/features/leads/cubit/leads_filter_cubit/leads_filter_cubit.dart';
import 'package:kommuno/features/leads/data/model/request/lead_filter_price_sort_order_data.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_date_sort_order_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_date_picker.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_dropdown.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_multi_selection_field.dart';

class FilterLeads extends StatelessWidget {
  const FilterLeads({super.key, this.leadsSourceCityProductStatusData});

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeadsFilterCubit(),
      child: _FilterLeadsState(
          leadsSourceCityProductStatusData: leadsSourceCityProductStatusData),
    );
  }
}

class _FilterLeadsState extends StatelessWidget {
  const _FilterLeadsState({this.leadsSourceCityProductStatusData});

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: _buildBody(context: context),
      ),
    );
  }

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  LeadsFilterCubit _leadsFilterCubit(BuildContext context) =>
      context.read<LeadsFilterCubit>();

  Widget _buildBody({required BuildContext context}) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Column(
        children: [
          BottomSheetHeader(
              title: AppLocalizations.of(context)!.filterAndSorting),
          Expanded(
            child: BlocListener<LeadsFilterCubit, LeadsFilterState>(
              listenWhen: (previousState, newState) {
                if (previousState is! LeadsFilterSuccessState &&
                    newState is LeadsFilterSuccessState) {
                  return true;
                }
                return false;
              },
              listener: (context, state) {
                if (state is LeadsFilterSuccessState) {
                  _leadsFilterCubit(context).initData();
                }
              },
              child: BlocConsumer<LeadsFilterCubit, LeadsFilterState>(
                listener: (context, state) {
                  if (state is LeadsFilterSuccessState) {
                    if (state.leadsFilterRequestModel != null) {
                      Navigator.of(context).pop(state.leadsFilterRequestModel);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is LeadsFilterInitialState) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        if (context.mounted) {
                          _leadsFilterCubit(context).getSourceCityProductStatus(
                              smeId: smeId,
                              leadsSourceCityProductStatusData:
                                  leadsSourceCityProductStatusData);
                        }
                      },
                    );
                  } else if (state is LeadsFilterLoadingState) {
                    return const AppLoadingIndicator(
                      color: AppColors.white,
                    );
                  } else if (state is LeadsFilterErrorState) {
                    return EmptyErrorWidget(
                      isOutlined: true,
                      text: AppLocalizations.of(context)!.somethingWentWrong,
                      style: AppTextStyle.white18,
                      onTap: () {
                        _leadsFilterCubit(context).getSourceCityProductStatus(
                            smeId: smeId,
                            leadsSourceCityProductStatusData:
                                leadsSourceCityProductStatusData);
                      },
                    );
                  } else if (state is LeadsFilterSuccessState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _kSized10,
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                LeadsDatePicker(
                                  key: ValueKey<String>(
                                      "LeadsMultiSelectionField_LeadsDatePicker_${state.selectedDateTimeRange.hashCode}"),
                                  value: state.selectedDateTimeRange != null
                                      ? "${DateUtility.getDateYMDOnly(date: state.selectedDateTimeRange!.start)}    ${DateUtility.getDateYMDOnly(date: state.selectedDateTimeRange!.end)}"
                                      : null,
                                  onSelectDateRange: (selectedDateTimeRange) {
                                    _leadsFilterCubit(context).selectDate(
                                        selectedDateTimeRange:
                                            selectedDateTimeRange);
                                  },
                                  hinText:
                                      AppLocalizations.of(context)!.selectDate,
                                ),
                                _kSized10,
                                LeadsMultiSelectionField(
                                  key: ValueKey<String>(
                                      "LeadsMultiSelectionField_LeadStatus_${state.selectedLeadsStatus.hashCode}"),
                                  title: AppLocalizations.of(context)!.status,
                                  value: state.selectedLeadsStatus.isNotEmpty
                                      ? state.selectedLeadsStatus
                                          .mapIndexed((index, e) => index ==
                                                  state.selectedLeadsStatus
                                                          .length -
                                                      1
                                              ? e.leadStatus
                                              : "${e.leadStatus}, ")
                                          .toList()
                                          .join()
                                      : null,
                                  onTap: () async {
                                    final selectedLeadsStatus =
                                        await multiSelectionDialog<LeadStatus>(
                                      title:
                                          AppLocalizations.of(context)!.status,
                                      constraints:
                                          const BoxConstraints(maxHeight: 400),
                                      context: context,
                                      items: state
                                          .leadsSourceCityProductStatusData
                                          .leadStatus,
                                      onBuildId: (value) {
                                        return "${value.id}";
                                      },
                                      onBuildText: (value) {
                                        return value.leadStatus;
                                      },
                                      selectedItems: state.selectedLeadsStatus,
                                    );
                                    if (selectedLeadsStatus != null &&
                                        context.mounted) {
                                      _leadsFilterCubit(context)
                                          .selectedLeadsStatus(
                                              selectedLeadsStatus:
                                                  selectedLeadsStatus);
                                    }
                                  },
                                ),
                                _kSized10,
                                LeadsMultiSelectionField(
                                  key: ValueKey<String>(
                                      "LeadsMultiSelectionField_LeadSource_${state.selectedLeadsSource.hashCode}"),
                                  title: AppLocalizations.of(context)!.source,
                                  value: state.selectedLeadsSource.isNotEmpty
                                      ? state.selectedLeadsSource
                                          .mapIndexed((index, e) => index ==
                                                  state.selectedLeadsSource
                                                          .length -
                                                      1
                                              ? e.source
                                              : "${e.source}, ")
                                          .toList()
                                          .join()
                                      : null,
                                  onTap: () async {
                                    final selectedLeadSource =
                                        await multiSelectionDialog<LeadSource>(
                                      title:
                                          AppLocalizations.of(context)!.source,
                                      constraints:
                                          const BoxConstraints(maxHeight: 400),
                                      context: context,
                                      items: state
                                          .leadsSourceCityProductStatusData
                                          .leadSource,
                                      onBuildId: (value) {
                                        return "${value.id}";
                                      },
                                      onBuildText: (value) {
                                        return value.source;
                                      },
                                      selectedItems: state.selectedLeadsSource,
                                    );
                                    if (selectedLeadSource != null &&
                                        context.mounted) {
                                      _leadsFilterCubit(context)
                                          .selectedLeadSource(
                                              selectedLeadSource:
                                                  selectedLeadSource);
                                    }
                                  },
                                ),
                                _kSized10,
                                LeadsMultiSelectionField(
                                  key: ValueKey<String>(
                                      "LeadsMultiSelectionField_LeadCity_${state.selectedLeadsCities.hashCode}"),
                                  title: AppLocalizations.of(context)!.city,
                                  value: state.selectedLeadsCities.isNotEmpty
                                      ? state.selectedLeadsCities
                                          .mapIndexed((index, e) => index ==
                                                  state.selectedLeadsCities
                                                          .length -
                                                      1
                                              ? e.cityName
                                              : "${e.cityName}, ")
                                          .toList()
                                          .join()
                                      : null,
                                  onTap: () async {
                                    final selectedLeadsCities =
                                        await multiSelectionDialog<LeadCity>(
                                      title: AppLocalizations.of(context)!.city,
                                      constraints:
                                          const BoxConstraints(maxHeight: 400),
                                      context: context,
                                      items: state
                                          .leadsSourceCityProductStatusData
                                          .cities,
                                      onBuildId: (value) {
                                        return "${value.cityId}";
                                      },
                                      onBuildText: (value) {
                                        return value.cityName;
                                      },
                                      selectedItems: state.selectedLeadsCities,
                                    );
                                    if (selectedLeadsCities != null &&
                                        context.mounted) {
                                      _leadsFilterCubit(context)
                                          .selectedLeadsCities(
                                              selectedLeadsCities:
                                                  selectedLeadsCities);
                                    }
                                  },
                                ),
                                _kSized10,
                                LeadsMultiSelectionField(
                                  key: ValueKey<String>(
                                      "LeadsMultiSelectionField_LeadProducts_${state.selectedLeadsProducts.hashCode}"),
                                  title: AppLocalizations.of(context)!.product,
                                  value: state.selectedLeadsProducts.isNotEmpty
                                      ? state.selectedLeadsProducts
                                          .mapIndexed((index, e) => index ==
                                                  state.selectedLeadsProducts
                                                          .length -
                                                      1
                                              ? e.productName
                                              : "${e.productName}, ")
                                          .toList()
                                          .join()
                                      : null,
                                  onTap: () async {
                                    final selectedLeadsProducts =
                                        await multiSelectionDialog<LeadProduct>(
                                      title:
                                          AppLocalizations.of(context)!.product,
                                      constraints:
                                          const BoxConstraints(maxHeight: 400),
                                      context: context,
                                      items: state
                                          .leadsSourceCityProductStatusData
                                          .products,
                                      onBuildId: (value) {
                                        return "${value.id}";
                                      },
                                      onBuildText: (value) {
                                        return value.productName ?? '';
                                      },
                                      selectedItems:
                                          state.selectedLeadsProducts,
                                    );
                                    if (selectedLeadsProducts != null &&
                                        context.mounted) {
                                      _leadsFilterCubit(context)
                                          .selectedLeadsProducts(
                                              selectedLeadsProducts:
                                                  selectedLeadsProducts);
                                    }
                                  },
                                ),
                                _kSized10,
                                ..._buildPriceField(
                                    context: context, state: state),
                                _kSized10,
                                ..._buildRadioTile(
                                    context: context, state: state),
                              ],
                            ),
                          ),
                        ),
                        _kSized20,
                        Row(
                          children: [
                            Expanded(
                              child: AppOutlineButton(
                                text: AppLocalizations.of(context)!.clearAll,
                                onTap: () {
                                  _leadsFilterCubit(context).clearAllFilters();
                                },
                              ),
                            ),
                            _kSized10,
                            Expanded(
                                child: AppOutlineButton(
                              text: AppLocalizations.of(context)!.apply,
                              onTap: () {
                                _leadsFilterCubit(context).applyFilters();
                              },
                            )),
                          ],
                        )
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

  List<Widget> _buildPriceField(
      {required BuildContext context, required LeadsFilterSuccessState state}) {
    return [
      LeadsDropdown<LeadFilterPriceSortOrderData>(
        enableDefaultBorder: false,
        value: state.selectedPriceValue,
        onChanged: (selectedPriceValue) {
          _leadsFilterCubit(context)
              .selectedPriceValue(selectedPriceValue: selectedPriceValue!);
        },
        title: AppLocalizations.of(context)!.price,
        items: LeadFilterPriceSortOrderData.priceOrderItems,
        onBuildText: (value) {
          return value.text;
        },
        onBuildValue: (value) {
          return value;
        },
      ),
      _kSized10,
      Row(
        children: [
          const SizedBox(
            width: AppConstant.leadsFieldTitleWidth,
          ),
          Expanded(
              child: AppTextField(
            controller: _leadsFilterCubit(context).priceController,
            minLines: 1,
            maxLines: 2,
            hintText: AppLocalizations.of(context)!.price,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5)
            ],
          )),
        ],
      )
    ];
  }

  List<Widget> _buildRadioTile(
      {required BuildContext context, required LeadsFilterSuccessState state}) {
    return [
      AppRadioTile<LeadsFilterDateSortOrderData?>(
        title: AppLocalizations.of(context)!.sortByLastCommunicationDate,
        value: LeadsFilterDateSortOrderData.leadsFilterDateSortOrderData[0],
        groupValue: state.selectedDateSortOrder,
        onChanged: (selectedSortOrder) {
          _leadsFilterCubit(context)
              .selectedDateSortOrder(selectedDateSortOrder: selectedSortOrder!);
        },
      ),
      AppRadioTile<LeadsFilterDateSortOrderData?>(
        title: AppLocalizations.of(context)!.sortByCreatedDate,
        value: LeadsFilterDateSortOrderData.leadsFilterDateSortOrderData[1],
        groupValue: state.selectedDateSortOrder,
        onChanged: (selectedSortOrder) {
          _leadsFilterCubit(context)
              .selectedDateSortOrder(selectedDateSortOrder: selectedSortOrder!);
        },
      ),
    ];
  }
}
