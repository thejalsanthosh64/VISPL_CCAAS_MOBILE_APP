part of 'lead_details_cubit.dart';

abstract class LeadDetailsState extends Equatable {
  const LeadDetailsState();
}

final class LeadDetailsInitialState extends LeadDetailsState {
  const LeadDetailsInitialState();

  @override
  List<Object> get props => [];
}

final class LeadDetailsLoadingState extends LeadDetailsState {
  const LeadDetailsLoadingState();

  @override
  List<Object> get props => [];
}

final class LeadDetailsSuccessState extends LeadDetailsState {
  const LeadDetailsSuccessState();

  @override
  List<Object> get props => [];
}
