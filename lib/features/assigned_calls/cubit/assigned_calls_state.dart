part of 'assigned_calls_cubit.dart';

abstract class AssignedCallsState extends Equatable {
  const AssignedCallsState();
}

final class AssignedCallsInitialState extends AssignedCallsState {
  const AssignedCallsInitialState();

  @override
  List<Object?> get props => [];
}

final class AssignedCallsLoadingState extends AssignedCallsState {
  const AssignedCallsLoadingState();

  @override
  List<Object?> get props => [];
}

final class AssignedCallsErrorState extends AssignedCallsState {
  const AssignedCallsErrorState();

  @override
  List<Object?> get props => [];
}

final class AssignedCallsSuccessState extends AssignedCallsState {
  final List<AssignedCallsDetails> assignedCallsDetails;
  final List<AssignedCallsDetails>? searchedAssignedCallsDetails;
  final int initialRecord;

  const AssignedCallsSuccessState({
    required this.assignedCallsDetails,
    required this.initialRecord,
    this.searchedAssignedCallsDetails,
  });

  AssignedCallsSuccessState copyWith({
    int? initialRecord,
    List<AssignedCallsDetails>? assignedCallsDetails,
    List<AssignedCallsDetails>? Function()? searchedAssignedCallsDetails,
  }) {
    return AssignedCallsSuccessState(
      initialRecord: initialRecord ?? this.initialRecord,
      assignedCallsDetails: assignedCallsDetails ?? this.assignedCallsDetails,
      searchedAssignedCallsDetails: searchedAssignedCallsDetails != null
          ? searchedAssignedCallsDetails()
          : this.searchedAssignedCallsDetails,
    );
  }

  @override
  List<Object?> get props =>
      [initialRecord, assignedCallsDetails, searchedAssignedCallsDetails];
}
