part of 'add_update_contact_cubit.dart';

final class AddUpdateContactState extends Equatable {
  const AddUpdateContactState({
    this.addNewContactDetails,
    this.customerName = '',
  });

  final AddUpdateContactsRequestModel? addNewContactDetails;

  final String customerName;

  AddUpdateContactState copyWith({
    AddUpdateContactsRequestModel? addNewContactDetails,
    String? customerName,
  }) {
    return AddUpdateContactState(
      addNewContactDetails: addNewContactDetails ?? this.addNewContactDetails,
      customerName: customerName ?? this.customerName,
    );
  }

  @override
  List<Object?> get props => [addNewContactDetails, customerName];
}
