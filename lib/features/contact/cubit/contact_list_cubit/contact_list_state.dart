part of 'contact_list_cubit.dart';

abstract class ContactListState extends Equatable {
  const ContactListState({required this.selectedMenu});

  final int selectedMenu;

  ContactListState parentCopyWith({int? selectedMenu});
}

final class ContactListInitial extends ContactListState {
  const ContactListInitial({required super.selectedMenu});

  @override
  ContactListInitial parentCopyWith({int? selectedMenu}) {
    return ContactListInitial(
      selectedMenu: selectedMenu ?? this.selectedMenu,
    );
  }

  @override
  List<Object?> get props => [selectedMenu];
}

final class ContactListLoadingState extends ContactListState {
  const ContactListLoadingState({required super.selectedMenu});

  @override
  ContactListLoadingState parentCopyWith({int? selectedMenu}) {
    return ContactListLoadingState(
      selectedMenu: selectedMenu ?? this.selectedMenu,
    );
  }

  @override
  List<Object?> get props => [selectedMenu];
}

final class ContactListErrorState extends ContactListState {
  const ContactListErrorState({required super.selectedMenu});

  @override
  ContactListErrorState parentCopyWith({int? selectedMenu}) {
    return ContactListErrorState(
      selectedMenu: selectedMenu ?? this.selectedMenu,
    );
  }

  @override
  List<Object?> get props => [];
}

final class ServerContactListState extends ContactListState {
  final List<ServerContactListModel> contactList;

  final List<ServerContactListModel>? searchList;

  final int initialRecord;

  const ServerContactListState({
    required super.selectedMenu,
    required this.contactList,
    this.searchList,
    required this.initialRecord,
  });

  ServerContactListState copyWith({
    int? selectedMenu,
    List<ServerContactListModel>? contactList,
    List<ServerContactListModel>? Function()? searchList,
    int? initialRecord,
  }) {
    return ServerContactListState(
      selectedMenu: selectedMenu ?? this.selectedMenu,
      contactList: contactList ?? this.contactList,
      searchList: searchList != null ? searchList() : this.searchList,
      initialRecord: initialRecord ?? this.initialRecord,
    );
  }

  @override
  ServerContactListState parentCopyWith({int? selectedMenu}) {
    return copyWith(selectedMenu: selectedMenu);
  }

  @override
  List<Object?> get props =>
      [contactList, searchList, initialRecord, selectedMenu];
}

final class DeviceContactListState extends ContactListState {
  final List<DeviceContactListModel> contactList;

  final List<DeviceContactListModel>? searchList;

  const DeviceContactListState({
    required super.selectedMenu,
    required this.contactList,
    this.searchList,
  });

  DeviceContactListState copyWith({
    int? selectedMenu,
    List<DeviceContactListModel>? contactList,
    List<DeviceContactListModel>? Function()? searchList,
  }) {
    return DeviceContactListState(
      selectedMenu: selectedMenu ?? this.selectedMenu,
      contactList: contactList ?? this.contactList,
      searchList: searchList != null ? searchList() : this.searchList,
    );
  }

  @override
  DeviceContactListState parentCopyWith({int? selectedMenu}) {
    return copyWith(selectedMenu: selectedMenu);
  }

  @override
  List<Object?> get props => [selectedMenu, contactList, searchList];
}
