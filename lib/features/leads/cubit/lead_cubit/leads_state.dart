part of 'leads_cubit.dart';

sealed class LeadsState extends Equatable {
  const LeadsState();
}

final class LeadsInitialState extends LeadsState {
  const LeadsInitialState();

  @override
  List<Object> get props => [];
}

final class LeadsLoadingState extends LeadsState {
  const LeadsLoadingState();

  @override
  List<Object> get props => [];
}

final class LeadsErrorState extends LeadsState {
  const LeadsErrorState();

  @override
  List<Object> get props => [];
}

final class LeadsSuccessState extends LeadsState {
  const LeadsSuccessState({
    required this.isExpanded,
    required this.initialRecord,
    required this.leadsUniqueCallsModel,
    this.leadsSourceCityProductStatusData,
  });

  final bool isExpanded;

  final int initialRecord;

  final List<LeadsUniqueCallsModel> leadsUniqueCallsModel;

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  LeadsSuccessState copyWith({
    bool? isExpanded,
    int? initialRecord,
    List<LeadsUniqueCallsModel>? leadsUniqueCallsModel,
    LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData,
  }) {
    return LeadsSuccessState(
      isExpanded: isExpanded ?? this.isExpanded,
      initialRecord: initialRecord ?? this.initialRecord,
      leadsUniqueCallsModel:
          leadsUniqueCallsModel ?? this.leadsUniqueCallsModel,
      leadsSourceCityProductStatusData: leadsSourceCityProductStatusData ??
          this.leadsSourceCityProductStatusData,
    );
  }

  @override
  List<Object?> get props => [
        isExpanded,
        initialRecord,
        leadsUniqueCallsModel,
        leadsSourceCityProductStatusData
      ];
}

final class LeadsFilterState extends LeadsState {
  const LeadsFilterState({
    required this.isExpanded,
    required this.initialRecord,
    required this.leadsUniqueCallsModel,
    required this.leadsFilterRequestModel,
    this.leadsSourceCityProductStatusData,
  });

  final bool isExpanded;

  final int initialRecord;

  final List<LeadsUniqueCallsModel> leadsUniqueCallsModel;

  final List<LeadsFilterRequestModel> leadsFilterRequestModel;

  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  LeadsFilterState copyWith(
      {bool? isExpanded,
      int? initialRecord,
      List<LeadsUniqueCallsModel>? leadsUniqueCallsModel,
      List<LeadsFilterRequestModel>? leadsFilterRequestModel,
      LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData}) {
    return LeadsFilterState(
      isExpanded: isExpanded ?? this.isExpanded,
      initialRecord: initialRecord ?? this.initialRecord,
      leadsUniqueCallsModel:
          leadsUniqueCallsModel ?? this.leadsUniqueCallsModel,
      leadsFilterRequestModel:
          leadsFilterRequestModel ?? this.leadsFilterRequestModel,
      leadsSourceCityProductStatusData: leadsSourceCityProductStatusData ??
          this.leadsSourceCityProductStatusData,
    );
  }

  @override
  List<Object?> get props => [
        isExpanded,
        initialRecord,
        leadsUniqueCallsModel,
        leadsFilterRequestModel,
        leadsSourceCityProductStatusData
      ];
}
