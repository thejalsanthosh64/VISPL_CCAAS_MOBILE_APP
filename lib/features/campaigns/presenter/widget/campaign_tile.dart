import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';

class CampaignTile extends StatelessWidget {
  const CampaignTile({
    super.key,
    required this.campaign,
    this.onChanged,
    this.isSelected = false,
  });

  final CampaignData campaign;
  final ValueChanged<CampaignData>? onChanged;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: isSelected,
      onChanged: onChanged != null
          ? (value) {
        onChanged?.call(campaign);
      }
          : null,
      title: Text(
        campaign.campaignName ?? "",
        style: AppTextStyle.appColor18,
      ),
    );
  }
}
