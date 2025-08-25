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

  const UserDetailsSuccessState({required this.userDetailsModel});

  @override
  List<Object?> get props => [userDetailsModel];
}
