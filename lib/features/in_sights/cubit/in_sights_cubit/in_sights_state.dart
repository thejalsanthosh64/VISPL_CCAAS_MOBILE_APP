part of 'in_sights_cubit.dart';

abstract class InSightsState extends Equatable {
  const InSightsState();
}

final class InSightsInitialState extends InSightsState {
  const InSightsInitialState();

  @override
  List<Object> get props => [];
}

final class InSightsLoadingState extends InSightsState {
  const InSightsLoadingState();

  @override
  List<Object> get props => [];
}

final class InSightsErrorState extends InSightsState {
  const InSightsErrorState();

  @override
  List<Object> get props => [];
}

final class InSightsSuccessState extends InSightsState {
  const InSightsSuccessState({
    required this.insightsResponse,
    this.dateTimeRange,
    this.inSightsDateEnum,
  });

  final InsightsResponse insightsResponse;

  final DateTimeRange? dateTimeRange;

  final InSightsDateEnum? inSightsDateEnum;

  InSightsSuccessState copyWith({
    InsightsResponse? insightsResponse,
    DateTimeRange? Function()? dateTimeRange,
    InSightsDateEnum? Function()? inSightsDateEnum,
  }) {
    return InSightsSuccessState(
      insightsResponse: insightsResponse ?? this.insightsResponse,
      dateTimeRange:
          dateTimeRange != null ? dateTimeRange() : this.dateTimeRange,
      inSightsDateEnum:
          inSightsDateEnum != null ? inSightsDateEnum() : this.inSightsDateEnum,
    );
  }

  @override
  List<Object?> get props =>
      [insightsResponse, dateTimeRange, inSightsDateEnum];
}
