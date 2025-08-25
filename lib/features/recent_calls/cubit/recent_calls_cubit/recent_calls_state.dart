part of 'recent_calls_cubit.dart';

abstract class RecentCallsState extends Equatable {
  const RecentCallsState();
}

final class RecentCallsInitialState extends RecentCallsState {
  const RecentCallsInitialState();

  @override
  List<Object> get props => [];
}

final class RecentCallsLoadingState extends RecentCallsState {
  const RecentCallsLoadingState();

  @override
  List<Object> get props => [];
}

final class RecentCallsErrorState extends RecentCallsState {
  const RecentCallsErrorState();

  @override
  List<Object> get props => [];
}

final class RecentCallsSuccessState extends RecentCallsState {
  const RecentCallsSuccessState({
    required this.initialRecord,
    required this.recentCallsData,
    this.searchedRecentCallsData,
    this.selectedDate,
    this.recentCallsRequestModel,
  });

  final int initialRecord;

  final List<RecentCallsData> recentCallsData;

  final List<RecentCallsData>? searchedRecentCallsData;

  final DateTimeRange? selectedDate;

  final List<RecentCallsRequestModel>? recentCallsRequestModel;

  RecentCallsSuccessState copyWith({
    int? initialRecord,
    List<RecentCallsData>? recentCallsData,
    List<RecentCallsData>? Function()? searchedRecentCallsData,
    DateTimeRange? Function()? selectedDate,
    List<RecentCallsRequestModel>? Function()? recentCallsRequestModel,
  }) {
    return RecentCallsSuccessState(
      initialRecord: initialRecord ?? this.initialRecord,
      recentCallsData: recentCallsData ?? this.recentCallsData,
      searchedRecentCallsData: searchedRecentCallsData != null
          ? searchedRecentCallsData()
          : this.searchedRecentCallsData,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      recentCallsRequestModel: recentCallsRequestModel != null
          ? recentCallsRequestModel()
          : this.recentCallsRequestModel,
    );
  }

  @override
  List<Object?> get props => [
        initialRecord,
        recentCallsData,
        searchedRecentCallsData,
        selectedDate,
        recentCallsRequestModel
      ];
}
