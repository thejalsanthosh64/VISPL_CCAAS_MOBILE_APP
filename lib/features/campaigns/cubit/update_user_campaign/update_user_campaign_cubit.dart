import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/campaigns/data/model/request/update_user_campaign_data.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';
import 'package:kommuno/features/campaigns/data/repository/campaign_repo.dart';

part 'update_user_campaign_state.dart';

class UpdateUserCampaignCubit extends Cubit<UpdateUserCampaignState> {
  UpdateUserCampaignCubit() : super(const UpdateUserCampaignState());

  final _campaignRepo = CampaignRepo();

  Future<void> updateUserCampaign({
    required UpdateUserCampaignData updateCampaignData,
    required CampaignData campaignData,
  }) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      final res = await _campaignRepo.updateUserCampaign(updateUserCampaign: updateCampaignData);
      if (res.isSuccess) {
        await CampaignManager.setCampaignInfo(campaign: campaignData);
        emit(const UpdateUserCampaignState(isCampaignUpdated: true));
      } else {
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("UpdateUserCampaignCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
