part of 'user_details_cubit.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
}

final class UserDetailsInitialState extends UserDetailsState {
  const UserDetailsInitialState();

  @override
  List<Object?> get props => [];
}

final class UserDetailsLoadingState extends UserDetailsState {
  const UserDetailsLoadingState();

  @override
  List<Object?> get props => [];
}

final class UserDetailsErrorState extends UserDetailsState {
  const UserDetailsErrorState();

  @override
  List<Object?> get props => [];
}

final class UserDetailsNotFoundState extends UserDetailsState {
  const UserDetailsNotFoundState();

  @override
  List<Object?> get props => [];
}

final class UserDetailsSuccessState extends UserDetailsState {
  final UserDetailsModel userDetailsModel;

  final String agentStatus;    
  final int waitingSeconds;   
    final int activeSeconds; 
  final int officeHours;


  const UserDetailsSuccessState({
    required this.userDetailsModel,
    this.agentStatus = "Waiting",
    this.waitingSeconds = 0,
        this.activeSeconds = 0, 
                this.officeHours = 0, 


  });

  UserDetailsSuccessState copyWith({
    UserDetailsModel? userDetailsModel,
    String? agentStatus,
    int? waitingSeconds,
        int? activeSeconds,
           int? officeHours


  }) {
    return UserDetailsSuccessState(
      userDetailsModel: userDetailsModel ?? this.userDetailsModel,
      agentStatus: agentStatus ?? this.agentStatus,
      waitingSeconds: waitingSeconds ?? this.waitingSeconds,
            activeSeconds: activeSeconds ?? this.activeSeconds,

            officeHours: officeHours ?? this.officeHours,

    );
  }

  @override
  List<Object?> get props => [
        userDetailsModel,
        agentStatus,
        waitingSeconds,
        activeSeconds,officeHours
      ];
}

