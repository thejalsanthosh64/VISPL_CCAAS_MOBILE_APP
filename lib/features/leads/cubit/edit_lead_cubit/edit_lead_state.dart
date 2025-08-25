part of 'edit_lead_cubit.dart';

abstract class EditLeadState extends Equatable {
  const EditLeadState();
}

final class EditLeadInitialState extends EditLeadState {
  const EditLeadInitialState();

  @override
  List<Object> get props => [];
}

final class EditLeadLoadingState extends EditLeadState {
  const EditLeadLoadingState();

  @override
  List<Object> get props => [];
}

final class EditLeadErrorState extends EditLeadState {
  const EditLeadErrorState();

  @override
  List<Object> get props => [];
}

final class EditLeadSuccessState extends EditLeadState {
  const EditLeadSuccessState({
    required this.leadsSourceCityProductStatusData,
    this.selectLeadStatus,
    this.selectLeadSource,
    this.selectLeadsCity,
    this.selectLeadsProduct,
    this.editLeadRequestData,
  });

  final LeadsSourceCityProductStatusData leadsSourceCityProductStatusData;
  final LeadStatus? selectLeadStatus;
  final LeadSource? selectLeadSource;
  final LeadCity? selectLeadsCity;
  final LeadProduct? selectLeadsProduct;
  final EditLeadRequestData? editLeadRequestData;

  EditLeadSuccessState copyWith({
    LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData,
    LeadStatus? Function()? selectLeadStatus,
    LeadSource? Function()? selectLeadSource,
    LeadCity? Function()? selectLeadsCity,
    LeadProduct? Function()? selectLeadsProduct,
    EditLeadRequestData? editLeadRequestData,
  }) {
    return EditLeadSuccessState(
      leadsSourceCityProductStatusData: leadsSourceCityProductStatusData ??
          this.leadsSourceCityProductStatusData,
      selectLeadStatus:
          selectLeadStatus != null ? selectLeadStatus() : this.selectLeadStatus,
      selectLeadSource:
          selectLeadSource != null ? selectLeadSource() : this.selectLeadSource,
      selectLeadsCity:
          selectLeadsCity != null ? selectLeadsCity() : this.selectLeadsCity,
      selectLeadsProduct: selectLeadsProduct != null
          ? selectLeadsProduct()
          : this.selectLeadsProduct,
      editLeadRequestData: editLeadRequestData ?? this.editLeadRequestData,
    );
  }

  @override
  List<Object?> get props => [
        leadsSourceCityProductStatusData,
        selectLeadStatus,
        selectLeadSource,
        selectLeadsCity,
        selectLeadsProduct,
        editLeadRequestData,
      ];
}
