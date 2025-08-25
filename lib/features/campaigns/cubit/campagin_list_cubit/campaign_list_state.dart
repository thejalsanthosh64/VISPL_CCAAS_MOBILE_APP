part of 'campaign_list_cubit.dart';

abstract class CampaignListState extends Equatable {
  const CampaignListState();
}

final class CampaignListInitialState extends CampaignListState {
  const CampaignListInitialState();

  @override
  List<Object?> get props => [];
}

final class CampaignListLoadingState extends CampaignListState {
  const CampaignListLoadingState();

  @override
  List<Object?> get props => [];
}

final class CampaignListErrorState extends CampaignListState {
  const CampaignListErrorState();

  @override
  List<Object?> get props => [];
}

final class CampaignListSuccessState extends CampaignListState {
  final List<CampaignData> campaignList;
  final String? selectedCampaign;

  const CampaignListSuccessState({
    required this.campaignList,
    this.selectedCampaign,
  });

  CampaignListSuccessState copyWith({
    List<CampaignData>? campaignList,
    String? Function()? selectedCampaign,
  }) {
    return CampaignListSuccessState(
      campaignList: campaignList ?? this.campaignList,
      selectedCampaign: selectedCampaign != null ? selectedCampaign() : this.selectedCampaign,
    );
  }

  @override
  List<Object?> get props => [campaignList, selectedCampaign];
}
