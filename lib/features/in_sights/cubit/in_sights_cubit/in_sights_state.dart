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
    required this.dispositionSummary,
    this.dateTimeRange,
    this.inSightsDateEnum,
  });

  final InsightsResponse insightsResponse;

  final DispositionSummaryResponse dispositionSummary;

  final DateTimeRange? dateTimeRange;
  final InSightsDateEnum? inSightsDateEnum;

  InSightsSuccessState copyWith({
    InsightsResponse? insightsResponse,
    DispositionSummaryResponse? dispositionSummary,
    DateTimeRange? Function()? dateTimeRange,
    InSightsDateEnum? Function()? inSightsDateEnum,
  }) {
    return InSightsSuccessState(
      insightsResponse: insightsResponse ?? this.insightsResponse,
      dispositionSummary:
          dispositionSummary ?? this.dispositionSummary,
      dateTimeRange:
          dateTimeRange != null ? dateTimeRange() : this.dateTimeRange,
      inSightsDateEnum:
          inSightsDateEnum != null ? inSightsDateEnum() : this.inSightsDateEnum,
    );
  }

  @override
  List<Object?> get props => [
        insightsResponse,
        dispositionSummary,
        dateTimeRange,
        inSightsDateEnum,
      ];
}
