part of 'leads_filter_cubit.dart';

sealed class LeadsFilterState extends Equatable {
  const LeadsFilterState();
}

final class LeadsFilterInitialState extends LeadsFilterState {
  const LeadsFilterInitialState();

  @override
  List<Object> get props => [];
}

final class LeadsFilterLoadingState extends LeadsFilterState {
  const LeadsFilterLoadingState();

  @override
  List<Object> get props => [];
}

final class LeadsFilterErrorState extends LeadsFilterState {
  const LeadsFilterErrorState();

  @override
  List<Object> get props => [];
}

final class LeadsFilterSuccessState extends LeadsFilterState {
  const LeadsFilterSuccessState({
    required this.leadsSourceCityProductStatusData,
    this.selectedLeadsSource = const [],
    this.selectedLeadsStatus = const [],
    this.selectedLeadsCities = const [],
    this.selectedLeadsProducts = const [],
    this.selectedDateTimeRange,
    this.selectedPriceValue,
    this.selectedDateSortOrder,
    this.leadsFilterRequestModel,
  });

  final LeadsSourceCityProductStatusData leadsSourceCityProductStatusData;

  final List<LeadSource> selectedLeadsSource;

  final List<LeadStatus> selectedLeadsStatus;

  final List<LeadCity> selectedLeadsCities;

  final List<LeadProduct> selectedLeadsProducts;

  final DateTimeRange? selectedDateTimeRange;

  final LeadFilterPriceSortOrderData? selectedPriceValue;

  final LeadsFilterDateSortOrderData? selectedDateSortOrder;

  final List<LeadsFilterRequestModel>? leadsFilterRequestModel;

  LeadsFilterSuccessState copyWith({
    LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData,
    List<LeadSource>? selectedLeadsSource,
    DateTimeRange? selectedDateTimeRange,
    List<LeadStatus>? selectedLeadsStatus,
    List<LeadCity>? selectedLeadsCities,
    List<LeadProduct>? selectedLeadsProducts,
    LeadFilterPriceSortOrderData? selectedPriceValue,
    LeadsFilterDateSortOrderData? selectedDateSortOrder,
    List<LeadsFilterRequestModel>? leadsFilterRequestModel,
  }) {
    return LeadsFilterSuccessState(
      leadsSourceCityProductStatusData: leadsSourceCityProductStatusData ??
          this.leadsSourceCityProductStatusData,
      selectedLeadsSource: selectedLeadsSource ?? this.selectedLeadsSource,
      selectedLeadsStatus: selectedLeadsStatus ?? this.selectedLeadsStatus,
      selectedLeadsCities: selectedLeadsCities ?? this.selectedLeadsCities,
      selectedLeadsProducts:
          selectedLeadsProducts ?? this.selectedLeadsProducts,
      selectedDateTimeRange:
          selectedDateTimeRange ?? this.selectedDateTimeRange,
      selectedPriceValue: selectedPriceValue ?? this.selectedPriceValue,
      selectedDateSortOrder:
          selectedDateSortOrder ?? this.selectedDateSortOrder,
      leadsFilterRequestModel:
          leadsFilterRequestModel ?? this.leadsFilterRequestModel,
    );
  }

  @override
  List<Object?> get props => [
        leadsSourceCityProductStatusData,
        selectedLeadsSource,
        selectedLeadsStatus,
        selectedLeadsCities,
        selectedLeadsProducts,
        selectedDateTimeRange,
        selectedPriceValue,
        selectedDateSortOrder,
        leadsFilterRequestModel,
      ];
}
