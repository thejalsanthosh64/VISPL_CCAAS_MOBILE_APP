part of 'add_lead_cubit.dart';

final class AddLeadState extends Equatable {
  final String? selectedStickyType;
  final AddMannualLeadRequestModel? addLeadRequestModel;

  const AddLeadState({this.selectedStickyType, this.addLeadRequestModel});

  AddLeadState copyWith({
    String? selectedStickyType,
    AddMannualLeadRequestModel? addLeadRequestModel,
  }) {
    return AddLeadState(
      addLeadRequestModel: addLeadRequestModel ?? this.addLeadRequestModel,
      selectedStickyType: selectedStickyType ?? this.selectedStickyType,
    );
  }

  @override
  List<Object?> get props => [selectedStickyType, addLeadRequestModel];
}
