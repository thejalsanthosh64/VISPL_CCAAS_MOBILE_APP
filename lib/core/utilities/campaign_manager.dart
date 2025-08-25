import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';
import 'secure_storage/secure_storage.dart';

abstract interface class CampaignManager {
  const CampaignManager();

  static CampaignData? _campaign;

  static CampaignData? get campaign => _campaign;

  static Future<void> setCampaignInfo({CampaignData? campaign}) async {
    try {
      if (campaign != null) {
        await SecureStorage().writeData(key: StorageEnum.campaignInfo.name, value: campaign.toJson());
        _campaign = campaign;
      } else {
        _campaign = null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getCampaignInfo() async {
    try {
      final data = await SecureStorage().readData(key: StorageEnum.campaignInfo.name);
      _campaign = CampaignData.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
