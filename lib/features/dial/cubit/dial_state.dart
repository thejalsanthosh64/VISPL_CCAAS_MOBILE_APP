part of 'dial_cubit.dart';

final class DialState extends Equatable {
  const DialState({this.number = '', this.isDialerOn = false,
    this.isUpdating = false,});

  final String number;
  final bool isDialerOn;
  final bool isUpdating;

  DialState copyWith({String? number, bool? isDialerOn,
    bool? isUpdating,}) {
    return DialState(number: number ?? this.number, isDialerOn: isDialerOn ?? this.isDialerOn,
      isUpdating: isUpdating ?? this.isUpdating,);
  }

  @override
  List<Object?> get props => [number,isDialerOn, isUpdating];
}
