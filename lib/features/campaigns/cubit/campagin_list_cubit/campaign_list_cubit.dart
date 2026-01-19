// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';
import 'package:kommuno/features/campaigns/data/repository/campaign_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'campaign_list_state.dart';

class CampaignListCubit extends Cubit<CampaignListState> {
  CampaignListCubit() : super(const CampaignListInitialState());

  final _campaignRepo = CampaignRepo();
    final loginInfo = UserLoginInfoManager.userLoginInfoModel!;

  Future<void> loadCampaigns({required int smeId}) async {
    try {
      emit(const CampaignListLoadingState());
      final res = await _campaignRepo.getCampaigns(smeId: smeId);
      if (res.isSuccess) {


      await _campaignRepo.updateWebrtcAgentStatus(
        smeId: smeId,
        agentId: loginInfo.userId,
     
      );

        final data = List<Map<String, dynamic>>.from(res.data as List);
        List<CampaignData> campaignList = [...data.map((e) => CampaignData.fromJson(e))];
        emit(CampaignListSuccessState(campaignList: campaignList));
      } else {
        emit(const CampaignListErrorState());
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      emit(const CampaignListErrorState());
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      emit(const CampaignListErrorState());
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("CampaignListCubit $e");
      debugPrint("$s");
    }
  }

  void onSelectCampaign({required String? id}) {
    if (state is CampaignListSuccessState) {
      final currentState = state as CampaignListSuccessState;
      emit(currentState.copyWith(selectedCampaign: () => id));
    }
  }
}
