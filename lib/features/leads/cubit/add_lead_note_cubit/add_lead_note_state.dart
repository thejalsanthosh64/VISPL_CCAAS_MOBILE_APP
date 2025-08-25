part of 'add_lead_note_cubit.dart';

@immutable
final class AddLeadNoteState extends Equatable {
  const AddLeadNoteState({this.addCustomerNoteRequest});

  final AddCustomerNoteRequest? addCustomerNoteRequest;

  @override
  List<Object?> get props => [addCustomerNoteRequest];
}
