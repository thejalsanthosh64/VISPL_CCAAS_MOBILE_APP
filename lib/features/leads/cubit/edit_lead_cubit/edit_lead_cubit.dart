// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/features/leads/data/model/request/edit_lead_request_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_unique_calls_model.dart';
import 'package:kommuno/features/leads/data/repository/lead_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'edit_lead_state.dart';

class EditLeadCubit extends Cubit<EditLeadState> {
  EditLeadCubit() : super(const EditLeadInitialState());

  final _leadRepo = LeadRepo();

  Future<void> getSourceCityProductStatus(
      {required int smeId,
      LeadsSourceCityProductStatusData?
          leadsSourceCityProductStatusData}) async {
    if (leadsSourceCityProductStatusData != null) {
      emit(EditLeadSuccessState(
          leadsSourceCityProductStatusData: leadsSourceCityProductStatusData));
    } else {
      try {
        emit(const EditLeadLoadingState());
        final res = await _leadRepo.getSourceCityProductStatus(smeId: smeId);
        if (res.isSuccess) {
          final leadsSourceCityProductStatusData =
              LeadsSourceCityProductStatusData.fromJson(res.data);
          emit(EditLeadSuccessState(
              leadsSourceCityProductStatusData:
                  leadsSourceCityProductStatusData));
        } else {
          emit(const EditLeadErrorState());
          FToastManager().showToast(message: res.message);
        }
      } on AppDioException catch (e) {
        emit(const EditLeadErrorState());
        FToastManager().showToast(message: e.message);
      } catch (e, s) {
        emit(const EditLeadErrorState());
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .somethingWentWrong);
        debugPrint("EditLeadCubit $e");
        debugPrint("$s");
      }
    }
  }

  void initData({required LeadsUniqueCallsModel leadsUniqueCall}) {
    if (state is EditLeadSuccessState) {
      final currentState = state as EditLeadSuccessState;

      LeadStatus? selectLeadStatus;
      LeadSource? selectLeadSource;
      LeadCity? selectLeadsCity;
      LeadProduct? selectLeadsProduct;

      selectLeadStatus = currentState
          .leadsSourceCityProductStatusData.leadStatus
          .firstWhereOrNull((e) => e.id == leadsUniqueCall.leadStatus);

      selectLeadSource = currentState
          .leadsSourceCityProductStatusData.leadSource
          .firstWhereOrNull((e) => e.id == leadsUniqueCall.sourceId);

      selectLeadsCity = currentState.leadsSourceCityProductStatusData.cities
          .firstWhereOrNull((e) => e.cityId == leadsUniqueCall.cityId);

      selectLeadsProduct = currentState
          .leadsSourceCityProductStatusData.products
          .firstWhereOrNull((e) => e.id == leadsUniqueCall.productId);

      emit(currentState.copyWith(
        selectLeadStatus: () => selectLeadStatus,
        selectLeadSource: () => selectLeadSource,
        selectLeadsCity: () => selectLeadsCity,
        selectLeadsProduct: () => selectLeadsProduct,
      ));
    }
  }

  void selectLeadStatus({required LeadStatus selectLeadStatus}) {
    if (state is EditLeadSuccessState) {
      emit((state as EditLeadSuccessState)
          .copyWith(selectLeadStatus: () => selectLeadStatus));
    }
  }

  void selectLeadSource({required LeadSource selectLeadSource}) {
    if (state is EditLeadSuccessState) {
      emit((state as EditLeadSuccessState)
          .copyWith(selectLeadSource: () => selectLeadSource));
    }
  }

  void selectLeadsCity({required LeadCity selectLeadsCity}) {
    if (state is EditLeadSuccessState) {
      emit((state as EditLeadSuccessState)
          .copyWith(selectLeadsCity: () => selectLeadsCity));
    }
  }

  void selectLeadsProduct({required LeadProduct selectLeadsProduct}) {
    if (state is EditLeadSuccessState) {
      emit((state as EditLeadSuccessState)
          .copyWith(selectLeadsProduct: () => selectLeadsProduct));
    }
  }

  Future<void> updateUniqueCalls({
    required EditLeadRequestData editLeadRequestData,
    required int smeId,
  }) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      final res = await _leadRepo.updateUniqueCalls(
        editLeadRequestData: editLeadRequestData,
        smeId: smeId,
      );
      if (res.isSuccess) {
        FToastManager().showToast(message: res.message);
        if (state is EditLeadSuccessState) {
          emit((state as EditLeadSuccessState)
              .copyWith(editLeadRequestData: editLeadRequestData));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("EditLeadCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
