part of 'follow_up_cubit.dart';

abstract class FollowUpState extends Equatable {
  const FollowUpState();
}

final class FollowUpInitialState extends FollowUpState {
  const FollowUpInitialState();

  @override
  List<Object?> get props => [];
}

final class FollowUpLoadingState extends FollowUpState {
  const FollowUpLoadingState();

  @override
  List<Object?> get props => [];
}

final class FollowUpErrorState extends FollowUpState {
  const FollowUpErrorState();

  @override
  List<Object?> get props => [];
}

final class FollowUpSuccessState extends FollowUpState {
  final List<FollowUpDetails> followUpListModel;
  final List<FollowUpDetails>? searchedFollowUpListModel;
  final int initialRecord;

  const FollowUpSuccessState({
    required this.followUpListModel,
    required this.initialRecord,
    this.searchedFollowUpListModel,
  });

  FollowUpSuccessState copyWith({
    int? initialRecord,
    List<FollowUpDetails>? followUpListModel,
    List<FollowUpDetails>? Function()? searchedFollowUpListModel,
  }) {
    return FollowUpSuccessState(
      initialRecord: initialRecord ?? this.initialRecord,
      followUpListModel: followUpListModel ?? this.followUpListModel,
      searchedFollowUpListModel: searchedFollowUpListModel != null
          ? searchedFollowUpListModel()
          : this.searchedFollowUpListModel,
    );
  }

  @override
  List<Object?> get props =>
      [initialRecord, followUpListModel, searchedFollowUpListModel];
}
