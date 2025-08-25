part of 'dial_cubit.dart';

final class DialState extends Equatable {
  const DialState({this.number = ''});

  final String number;

  DialState copyWith({String? number}) {
    return DialState(number: number ?? this.number);
  }

  @override
  List<Object?> get props => [number];
}
