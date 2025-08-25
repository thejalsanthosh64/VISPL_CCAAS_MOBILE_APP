part of 'update_user_campaign_cubit.dart';

final class UpdateUserCampaignState extends Equatable {
  const UpdateUserCampaignState({
    this.isCampaignUpdated = false,
  });

  final bool isCampaignUpdated;

  @override
  List<Object?> get props => [isCampaignUpdated];
}
