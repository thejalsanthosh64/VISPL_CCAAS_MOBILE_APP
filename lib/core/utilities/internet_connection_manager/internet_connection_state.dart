part of 'internet_connection_cubit.dart';

abstract class InternetConnectionState extends Equatable {
  const InternetConnectionState();
}

final class InternetConnectionInitial extends InternetConnectionState {

  const InternetConnectionInitial();

  @override
  List<Object?> get props => [];
}

final class InternetConnectedState extends InternetConnectionState {

  const InternetConnectedState();
  @override
  List<Object?> get props => [];
}

final class InternetDisConnectedState extends InternetConnectionState {

  const InternetDisConnectedState();
  @override
  List<Object?> get props => [];
}