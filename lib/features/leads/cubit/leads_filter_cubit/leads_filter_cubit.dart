// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';
import 'package:kommuno/features/leads/data/model/request/lead_filter_price_sort_order_data.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_date_sort_order_data.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_request_model.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:kommuno/features/leads/data/repository/lead_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'leads_filter_state.dart';

class LeadsFilterCubit extends Cubit<LeadsFilterState> {
  LeadsFilterCubit() : super(const LeadsFilterInitialState());

  final _leadRepo = LeadRepo();

  final priceController = TextEditingController();

  @override
  Future<void> close() async {
    priceController.dispose();
    super.close();
  }

  void initData() async {
    if (state is LeadsFilterSuccessState) {
      final currentState = state as LeadsFilterSuccessState;
      try {
        final data = await HiveService.getData(
            hiveKeysEnum: HiveKeysEnum.leadsFilterData);
        final leadsFilterRequestModel =
            List<LeadsFilterRequestModel>.from(data ?? []);
        List<LeadSource> selectedLeadsSource = [];

        List<LeadStatus> selectedLeadsStatus = [];

        List<LeadCity> selectedLeadsCities = [];

        List<LeadProduct> selectedLeadsProducts = [];

        DateTimeRange? selectedDateTimeRange;

        LeadFilterPriceSortOrderData? selectedPriceValue;

        LeadsFilterDateSortOrderData? selectedDateSortOrder;
        for (var value in leadsFilterRequestModel) {
          switch (value.leadFilterEnum) {
            case LeadFilterEnum.createdDate:
              break;
            case LeadFilterEnum.agentId:
              break;
            case LeadFilterEnum.searchLeads:
              break;
            case LeadFilterEnum.startDate:
              final dateTime = DateTime.parse(value.val);
              selectedDateTimeRange = DateTimeRange(
                  start: dateTime,
                  end: selectedDateTimeRange?.end ??
                      dateTime.add(const Duration(days: 1)));
              break;
            case LeadFilterEnum.endDate:
              final dateTime = DateTime.parse(value.val);
              selectedDateTimeRange = DateTimeRange(
                  start: selectedDateTimeRange?.start ??
                      dateTime.subtract(const Duration(days: 1)),
                  end: dateTime);
              break;
            case LeadFilterEnum.leadStatus:
              selectedLeadsStatus = currentState
                  .leadsSourceCityProductStatusData.leadStatus
                  .where((e) {
                return value.val
                    .split(",")
                    .map((e) => e.trim())
                    .contains("${e.id}");
              }).toList();
              break;
            case LeadFilterEnum.leadSource:
              selectedLeadsSource = currentState
                  .leadsSourceCityProductStatusData.leadSource
                  .where((e) {
                return value.val
                    .split(",")
                    .map((e) => e.trim())
                    .contains("${e.id}");
              }).toList();
              break;
            case LeadFilterEnum.cityId:
              selectedLeadsCities = currentState
                  .leadsSourceCityProductStatusData.cities
                  .where((e) {
                return value.val
                    .split(",")
                    .map((e) => e.trim())
                    .contains("${e.cityId}");
              }).toList();
              break;
            case LeadFilterEnum.productId:
              selectedLeadsProducts = currentState
                  .leadsSourceCityProductStatusData.products
                  .where((e) {
                return value.val
                    .split(",")
                    .map((e) => e.trim())
                    .contains("${e.id}");
              }).toList();
              break;
            case LeadFilterEnum.productPriceLessThan:
              selectedPriceValue =
                  LeadFilterPriceSortOrderData.priceOrderItems[0];
              priceController.text = value.val;
              break;
            case LeadFilterEnum.productPriceGreaterThan:
              selectedPriceValue =
                  LeadFilterPriceSortOrderData.priceOrderItems[1];
              priceController.text = value.val;
              break;
            case LeadFilterEnum.productPriceEqualTo:
              selectedPriceValue =
                  LeadFilterPriceSortOrderData.priceOrderItems[2];
              priceController.text = value.val;
              break;
            case LeadFilterEnum.communicationDate:
              selectedDateSortOrder = LeadsFilterDateSortOrderData
                  .leadsFilterDateSortOrderData
                  .firstWhereOrNull((e) {
                return value.val == e.value;
              });
          }
        }
        emit(currentState.copyWith(
          selectedPriceValue: selectedPriceValue,
          selectedDateTimeRange: selectedDateTimeRange,
          selectedLeadsCities: selectedLeadsCities,
          selectedLeadsProducts: selectedLeadsProducts,
          selectedLeadsSource: selectedLeadsSource,
          selectedLeadsStatus: selectedLeadsStatus,
          selectedDateSortOrder: selectedDateSortOrder,
        ));
      } catch (e, s) {
        debugPrint("HiveService LeadsFilterCubit $e");
        debugPrint("$s");
      }
    }
  }

  Future<void> getSourceCityProductStatus(
      {required int smeId,
      LeadsSourceCityProductStatusData?
          leadsSourceCityProductStatusData}) async {
    if (leadsSourceCityProductStatusData != null) {
      emit(LeadsFilterSuccessState(
          leadsSourceCityProductStatusData: leadsSourceCityProductStatusData));
    } else {
      try {
        emit(const LeadsFilterLoadingState());
        final res = await _leadRepo.getSourceCityProductStatus(smeId: smeId);
        if (res.isSuccess) {
          final leadsSourceCityProductStatusData =
              LeadsSourceCityProductStatusData.fromJson(res.data);
          emit(LeadsFilterSuccessState(
              leadsSourceCityProductStatusData:
                  leadsSourceCityProductStatusData));
        } else {
          emit(const LeadsFilterErrorState());
          FToastManager().showToast(message: res.message);
        }
      } on AppDioException catch (e) {
        emit(const LeadsFilterErrorState());
        FToastManager().showToast(message: e.message);
      } catch (e, s) {
        emit(const LeadsFilterErrorState());
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .somethingWentWrong);
        debugPrint("LeadsFilterCubit $e");
        debugPrint("$s");
      }
    }
  }

  void selectDate({required DateTimeRange selectedDateTimeRange}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedDateTimeRange: selectedDateTimeRange));
    }
  }

  void selectedLeadSource({required List<LeadSource> selectedLeadSource}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedLeadsSource: selectedLeadSource));
    }
  }

  void selectedLeadsStatus({required List<LeadStatus> selectedLeadsStatus}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedLeadsStatus: selectedLeadsStatus));
    }
  }

  void selectedLeadsCities({required List<LeadCity> selectedLeadsCities}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedLeadsCities: selectedLeadsCities));
    }
  }

  void selectedLeadsProducts(
      {required List<LeadProduct> selectedLeadsProducts}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedLeadsProducts: selectedLeadsProducts));
    }
  }

  void selectedPriceValue(
      {required LeadFilterPriceSortOrderData selectedPriceValue}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedPriceValue: selectedPriceValue));
    }
  }

  void selectedDateSortOrder(
      {required LeadsFilterDateSortOrderData selectedDateSortOrder}) {
    if (state is LeadsFilterSuccessState) {
      emit((state as LeadsFilterSuccessState)
          .copyWith(selectedDateSortOrder: selectedDateSortOrder));
    }
  }

  void clearAllFilters() {
    if (state is LeadsFilterSuccessState) {
      priceController.clear();
      emit(LeadsFilterSuccessState(
        leadsSourceCityProductStatusData:
            (state as LeadsFilterSuccessState).leadsSourceCityProductStatusData,
      ));
    }
  }

  void applyFilters() {
    if (state is LeadsFilterSuccessState) {
      final currentState = state as LeadsFilterSuccessState;
      if (currentState.selectedPriceValue == null &&
          priceController.text.trim().isNotEmpty) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseSelectPriceSortOrder);
      } else if (currentState.selectedPriceValue != null &&
          priceController.text.trim().isEmpty) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnterPrice);
      } else {
        final leadsFilterRequestModel = <LeadsFilterRequestModel>[];
        if (currentState.selectedDateTimeRange != null) {
          leadsFilterRequestModel.addAll(
            [
              LeadsFilterRequestModel(
                leadFilterEnum: LeadFilterEnum.startDate,
                val: DateUtility.getDateYMDOnly(
                  date: currentState.selectedDateTimeRange!.start,
                ),
              ),
              LeadsFilterRequestModel(
                leadFilterEnum: LeadFilterEnum.endDate,
                val: DateUtility.getDateYMDOnly(
                  date: currentState.selectedDateTimeRange!.end,
                ),
              )
            ],
          );
        }

        if (currentState.selectedLeadsStatus.isNotEmpty) {
          final value = currentState.selectedLeadsStatus
              .mapIndexed((index, e) =>
                  index == currentState.selectedLeadsStatus.length - 1
                      ? e.id
                      : "${e.id},")
              .toList()
              .join();
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              val: value, leadFilterEnum: LeadFilterEnum.leadStatus));
        }

        if (currentState.selectedLeadsSource.isNotEmpty) {
          final value = currentState.selectedLeadsSource
              .mapIndexed((index, e) =>
                  index == currentState.selectedLeadsSource.length - 1
                      ? e.id
                      : "${e.id},")
              .toList()
              .join();
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              val: value, leadFilterEnum: LeadFilterEnum.leadSource));
        }

        if (currentState.selectedLeadsCities.isNotEmpty) {
          final value = currentState.selectedLeadsCities
              .mapIndexed((index, e) =>
                  index == currentState.selectedLeadsCities.length - 1
                      ? e.cityId
                      : "${e.cityId},")
              .toList()
              .join();
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              val: value, leadFilterEnum: LeadFilterEnum.cityId));
        }

        if (currentState.selectedLeadsProducts.isNotEmpty) {
          final value = currentState.selectedLeadsProducts
              .mapIndexed((index, e) =>
                  index == currentState.selectedLeadsProducts.length - 1
                      ? e.id
                      : "${e.id},")
              .toList()
              .join();
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              val: value, leadFilterEnum: LeadFilterEnum.productId));
        }

        if (currentState.selectedPriceValue != null) {
          switch (currentState.selectedPriceValue!.id) {
            case 0:
              leadsFilterRequestModel.add(LeadsFilterRequestModel(
                  val: priceController.text,
                  leadFilterEnum: LeadFilterEnum.productPriceLessThan));
              break;
            case 1:
              leadsFilterRequestModel.add(LeadsFilterRequestModel(
                  val: priceController.text,
                  leadFilterEnum: LeadFilterEnum.productPriceGreaterThan));
              break;
            case 2:
              leadsFilterRequestModel.add(LeadsFilterRequestModel(
                  val: priceController.text,
                  leadFilterEnum: LeadFilterEnum.productPriceEqualTo));
              break;
          }
        }

        if (currentState.selectedDateSortOrder != null) {
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              val: currentState.selectedDateSortOrder!.value,
              leadFilterEnum: LeadFilterEnum.communicationDate));
        }
        if (leadsFilterRequestModel.isNotEmpty) {
          leadsFilterRequestModel.add(LeadsFilterRequestModel(
              leadFilterEnum: LeadFilterEnum.agentId,
              val: "${UserLoginInfoManager.userLoginInfoModel!.userId}"));
        }

        emit(currentState.copyWith(
            leadsFilterRequestModel: leadsFilterRequestModel));
      }
    }
  }
}
