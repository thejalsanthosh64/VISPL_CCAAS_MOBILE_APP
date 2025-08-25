part of 'remarks_cubit.dart';

sealed class RemarksState extends Equatable {
  const RemarksState();
}

final class RemarksInitialState extends RemarksState {
  const RemarksInitialState();

  @override
  List<Object> get props => [];
}

final class RemarksLoadingState extends RemarksState {
  const RemarksLoadingState();

  @override
  List<Object> get props => [];
}

final class RemarksErrorState extends RemarksState {
  const RemarksErrorState();

  @override
  List<Object> get props => [];
}

final class RemarksSuccessState extends RemarksState {
  final List<RemarksDataModel> remarksDataModel;

  final SendRemarksRequestModel? sendRemarksRequestModel;

  final bool isSendButtonVisible;

  const RemarksSuccessState({
    required this.remarksDataModel,
    this.sendRemarksRequestModel,
    this.isSendButtonVisible = false,
  });

  RemarksSuccessState copyWith({
    List<RemarksDataModel>? remarksDataModel,
    SendRemarksRequestModel? sendRemarksRequestModel,
    bool? isSendButtonVisible,
  }) {
    return RemarksSuccessState(
      remarksDataModel: remarksDataModel ?? this.remarksDataModel,
      sendRemarksRequestModel:
          sendRemarksRequestModel ?? this.sendRemarksRequestModel,
      isSendButtonVisible: isSendButtonVisible ?? this.isSendButtonVisible,
    );
  }

  @override
  List<Object?> get props =>
      [remarksDataModel, sendRemarksRequestModel, isSendButtonVisible];
}
