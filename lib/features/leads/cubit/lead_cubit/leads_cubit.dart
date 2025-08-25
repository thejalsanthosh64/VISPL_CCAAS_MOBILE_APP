// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_request_model.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_unique_calls_model.dart';
import 'package:kommuno/features/leads/data/repository/lead_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'leads_state.dart';

class LeadsCubit extends Cubit<LeadsState> {
  LeadsCubit() : super(const LeadsInitialState());

  final paginationScrollController = PaginationScrollController();

  final paginationSearchScrollController = PaginationScrollController();

  final _leadRepo = LeadRepo();

  final leadSearchController = TextEditingController();

  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  Future<void> close() async {
    debouncer.cancel();
    leadSearchController.dispose();
    paginationSearchScrollController.dispose();
    paginationScrollController.dispose();
    super.close();
  }

  Future<bool> getLeadsUniqueCalls({
    bool isLoading = true,
    required int smeId,
    int? initialRecordValue,
    bool checkFilterApply = false,
  }) async {
    if (checkFilterApply) {
      try {
        final data = await HiveService.getData(
            hiveKeysEnum: HiveKeysEnum.leadsFilterData);
        final leadsFilterRequestModel =
            List<LeadsFilterRequestModel>.from(data ?? []);
        if (leadsFilterRequestModel.isNotEmpty) {
          final search = leadsFilterRequestModel.firstWhereOrNull(
              (e) => e.leadFilterEnum == LeadFilterEnum.searchLeads);
          leadSearchController.text = search?.val ?? '';
          return await getFilterLeadsUniqueCalls(
            smeId: smeId,
            leadsFilterRequestModel: leadsFilterRequestModel,
            isLoading: true,
          );
        }
      } catch (e, s) {
        debugPrint("HiveService leadsFilterData $e");
        debugPrint("$s");
      }
    }
    leadSearchController.clear();
    bool hasMoreData = true;
    try {
      int batchSize = 20;
      int initialRecord = 1;
      if (isLoading) {
        emit(const LeadsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        if (state is LeadsSuccessState) {
          initialRecord = initialRecordValue ??
              (state as LeadsSuccessState).initialRecord + batchSize;
        }
      }

      final res = await _leadRepo.getLeadsUniqueCalls(
          initialRecord: initialRecord, smeId: smeId, batchSize: batchSize);
      if (res.isSuccess) {
        final leadsUniqueCallsModel = List<LeadsUniqueCallsModel>.from(
          (res.data as List<dynamic>).map(
            (e) => LeadsUniqueCallsModel.fromJson(e),
          ),
        );

        if (leadsUniqueCallsModel.length < batchSize) {
          hasMoreData = false;
          paginationScrollController.hasMoreData = false;
        } else {
          paginationScrollController.hasMoreData = true;
        }
        if (state is LeadsSuccessState) {
          final currentState = state as LeadsSuccessState;
          List<LeadsUniqueCallsModel> list = [];
          if (initialRecordValue == 1) {
            list = [...leadsUniqueCallsModel];
          } else {
            list = [...currentState.leadsUniqueCallsModel];
            list.addAll(leadsUniqueCallsModel);
          }

          emit((state as LeadsSuccessState).copyWith(
            initialRecord: initialRecord,
            leadsUniqueCallsModel: list,
          ));
        } else {
          emit(LeadsSuccessState(
              leadsSourceCityProductStatusData: state is LeadsFilterState
                  ? (state as LeadsFilterState).leadsSourceCityProductStatusData
                  : null,
              initialRecord: initialRecord,
              leadsUniqueCallsModel: leadsUniqueCallsModel,
              isExpanded: state is LeadsFilterState
                  ? (state as LeadsFilterState).isExpanded
                  : false));
        }
      } else {
        if (isLoading) {
          emit(const LeadsErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const LeadsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const LeadsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("LeadsCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
    return hasMoreData;
  }

  void changeExpandedState(bool isExpanded) {
    if (state is LeadsSuccessState) {
      emit((state as LeadsSuccessState).copyWith(isExpanded: isExpanded));
    } else if (state is LeadsFilterState) {
      emit((state as LeadsFilterState).copyWith(isExpanded: isExpanded));
    }
  }

  Future<bool> getFilterLeadsUniqueCalls({
    required int smeId,
    required List<LeadsFilterRequestModel> leadsFilterRequestModel,
    int? initialRecordValue,
    bool isLoading = false,
  }) async {
    bool hasMoreData = true;
    try {
      int batchSize = 20;
      int initialRecord = 1;
      if (isLoading) {
        emit(const LeadsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        if (state is LeadsFilterState) {
          initialRecord = initialRecordValue ??
              (state as LeadsSuccessState).initialRecord + batchSize;
        }
      }

      final res = await _leadRepo.getLeadsUniqueCalls(
          leadsFilterRequestModel: leadsFilterRequestModel,
          initialRecord: initialRecord,
          smeId: smeId,
          batchSize: batchSize);
      if (res.isSuccess) {
        final leadsUniqueCallsModel = List<LeadsUniqueCallsModel>.from(
          (res.data as List<dynamic>).map(
            (e) => LeadsUniqueCallsModel.fromJson(e),
          ),
        );

        if (leadsUniqueCallsModel.length < batchSize) {
          hasMoreData = false;
          paginationSearchScrollController.hasMoreData = false;
        } else {
          paginationSearchScrollController.hasMoreData = true;
        }
        if (state is LeadsFilterState) {
          final currentState = state as LeadsFilterState;
          List<LeadsUniqueCallsModel> list = [];
          if (initialRecordValue == 1) {
            list = [...leadsUniqueCallsModel];
          } else {
            list = [...currentState.leadsUniqueCallsModel];
            list.addAll(leadsUniqueCallsModel);
          }
          emit((state as LeadsFilterState).copyWith(
              initialRecord: initialRecord,
              leadsUniqueCallsModel: list,
              leadsFilterRequestModel: leadsFilterRequestModel));
        } else {
          emit(LeadsFilterState(
              leadsSourceCityProductStatusData: state is LeadsSuccessState
                  ? (state as LeadsSuccessState)
                      .leadsSourceCityProductStatusData
                  : null,
              leadsFilterRequestModel: leadsFilterRequestModel,
              initialRecord: initialRecord,
              leadsUniqueCallsModel: leadsUniqueCallsModel,
              isExpanded: state is LeadsSuccessState
                  ? (state as LeadsSuccessState).isExpanded
                  : false));
        }
      } else {
        if (isLoading) {
          emit(const LeadsErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const LeadsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const LeadsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("LeadsCubit $e");
      debugPrint("$s");
    }

    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }

    return hasMoreData;
  }

  void searchLeadsUniqueCalls({required String text, required int smeId}) {
    if (state is LeadsSuccessState || state is LeadsFilterState) {
      final searchedTex = text.trim().toLowerCase();
      if (!(text.isNotEmpty && searchedTex.isEmpty)) {
        final previousFilterDataRequest = state is LeadsFilterState
            ? (state as LeadsFilterState).leadsFilterRequestModel
            : <LeadsFilterRequestModel>[];
        previousFilterDataRequest.removeWhere((e) =>
            e.leadFilterEnum == LeadFilterEnum.agentId ||
            e.leadFilterEnum == LeadFilterEnum.searchLeads);
        if (searchedTex.isEmpty) {
          if (previousFilterDataRequest.isEmpty) {
            getLeadsUniqueCalls(
              smeId: smeId,
              isLoading: false,
              initialRecordValue: 1,
            );
          } else {
            getFilterLeadsUniqueCalls(
              initialRecordValue: 1,
              smeId: smeId,
              leadsFilterRequestModel: previousFilterDataRequest,
            );
          }
        } else {
          getFilterLeadsUniqueCalls(
            initialRecordValue: 1,
            smeId: smeId,
            leadsFilterRequestModel: [
              LeadsFilterRequestModel(
                  leadFilterEnum: LeadFilterEnum.searchLeads, val: searchedTex),
              LeadsFilterRequestModel(
                  leadFilterEnum: LeadFilterEnum.agentId,
                  val: "${UserLoginInfoManager.userLoginInfoModel!.userId}"),
              ...previousFilterDataRequest
            ],
          );
        }
      }
    }
  }

  Future<void> getSourceCityProductStatus({required int smeId}) async {
    try {
      final res = await _leadRepo.getSourceCityProductStatus(smeId: smeId);
      if (res.isSuccess) {
        final leadsSourceCityProductStatusData =
            LeadsSourceCityProductStatusData.fromJson(res.data);
        if (state is LeadsSuccessState) {
          emit((state as LeadsSuccessState).copyWith(
              leadsSourceCityProductStatusData:
                  leadsSourceCityProductStatusData));
        } else if (state is LeadsFilterState) {
          emit((state as LeadsFilterState).copyWith(
              leadsSourceCityProductStatusData:
                  leadsSourceCityProductStatusData));
        }
      }
    } catch (e, s) {
      debugPrint("LeadsCubit $e");
      debugPrint("$s");
    }
  }
}
