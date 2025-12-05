// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/core/utilities/permission_handler/permission_handler.dart';
import 'package:kommuno/core/utilities/regex.dart';
import 'package:kommuno/features/contact/data/model/contact_list_request_model.dart';
import 'package:kommuno/features/contact/data/model/device_contact_list_model.dart';
import 'package:kommuno/features/contact/data/model/server_contact_response_model.dart';
import 'package:kommuno/features/contact/data/repository/contact_repo.dart';
import 'package:kommuno/features/contact/presenter/widget/alphabetic_list.dart';
import 'package:kommuno/features/contact/presenter/widget/contact_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'contact_list_state.dart';

class ContactListCubit extends Cubit<ContactListState> {
  ContactListCubit() : super(const ContactListInitial(selectedMenu: 1));

  final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  final _contactRepo = ContactRepo();

  final paginationScrollController = PaginationScrollController();

  @override
  Future<void> close() async {
    debouncer.cancel();
    paginationScrollController.dispose();
    super.close();
  }

  Future<void> loadDeviceContacts({
    required int previousSelectedMenu,
    required BuildContext context,
    bool isLoading = true,
  }) async {
    try {
      if (await AppPermissionHandler.checkPermission(
          context: context, permission: Permission.contacts)) {
        if (isLoading) {
          emit(ContactListLoadingState(selectedMenu: state.selectedMenu));
        } else {
          AppLoadingIndicator.showLoadingIndicator();
        }

        final contacts = await FlutterContacts.getContacts(
            withThumbnail: true, sorted: true, withProperties: true);
        final contactList = _groupByDevicesList(contacts: contacts);

 for (var group in contactList) {
        for (var c in group.contactDisplayDetails) {
          final dn = c.displayName?.trim() ?? "";
          if (dn.isNotEmpty && dn.toLowerCase() != "unknown") {
            ContactLookup.deviceNames[
              ContactLookup.normalize(c.number)
            ] = dn;
          }
        }
      }
        emit(DeviceContactListState(
            contactList: contactList, selectedMenu: state.selectedMenu));
      } else {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .allPermission);
        emit(state.parentCopyWith(selectedMenu: previousSelectedMenu));
      }
    } catch (e) {
      if (isLoading) {
        emit(ContactListErrorState(selectedMenu: state.selectedMenu));
      }
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }

  /// bool refers has More data
  Future<bool> loadServerContacts({
    bool isLoading = true,
    required String smeId,
    int? initialRecordValue,
  }) async {
    bool hasMoreData = true;
    try {
      int batchSize = 20;
      int initialRecord = 1;
      if (isLoading) {


        
        emit(ContactListLoadingState(selectedMenu: state.selectedMenu));
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        if (state is ServerContactListState) {
          initialRecord = initialRecordValue ??
              (state as ServerContactListState).initialRecord + batchSize;
        }
      }

      final res = await _contactRepo.getAllContacts(
          getContactsRequestModel: GetContactsRequestModel(
        batchSize: batchSize,
        initialRecord: initialRecord,
        smeId: smeId,
      ));
      if (res.isSuccess) {
        final data = List<Map<String, dynamic>>.from(res.data as List);
        if (data.length < batchSize) {
          hasMoreData = false;
          paginationScrollController.hasMoreData = false;
        } else {
          paginationScrollController.hasMoreData = true;
        }
        if (state is ServerContactListState) {
          List<ServerContactsResponseModel> contacts = [];
          if (initialRecordValue == 1) {
            contacts = [
              ...data.map((e) => ServerContactsResponseModel.fromJson(e))
            ];
          } else {
            List<ServerContactsResponseModel> previousList =
                <ServerContactsResponseModel>[];
            for (var contact in (state as ServerContactListState).contactList) {
              previousList.addAll(contact.contactDisplayDetails);
            }
            contacts = [
              ...previousList,
              ...data.map((e) => ServerContactsResponseModel.fromJson(e))
            ];
          }
          final contactList = _groupByServerList(contacts: contacts);
for (var group in contactList) {
          for (var c in group.contactDisplayDetails) {
            final name = c.customerName.trim();
            if (name.isNotEmpty && name.toLowerCase() != "unknown" && name.toLowerCase() != "no name") {
              ContactLookup.serverNames[
                ContactLookup.normalize(c.customerNumberPrimary)
              ] = name;
            }
          }
        }

        debugPrint(" Server contacts loaded: ${ContactLookup.serverNames.length}");




          emit((state as ServerContactListState).copyWith(
              contactList: contactList, initialRecord: initialRecord));
        } else {
          final contactList = _groupByServerList(
              contacts: data
                  .map((e) => ServerContactsResponseModel.fromJson(e))
                  .toList());
          emit(ServerContactListState(
              selectedMenu: state.selectedMenu,
              contactList: contactList,
              initialRecord: initialRecord));
        }
      } else {
        if (isLoading) {
          emit(ContactListErrorState(selectedMenu: state.selectedMenu));
        }

        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(ContactListErrorState(selectedMenu: state.selectedMenu));
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(ContactListErrorState(selectedMenu: state.selectedMenu));
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("ContactListCubit $e");
      debugPrint("$s");
    }

    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
    return hasMoreData;
  }

  List<ServerContactListModel> _groupByServerList(
      {required List<ServerContactsResponseModel> contacts}) {
    final namedContact = <ServerContactsResponseModel>[];

    final unNamedContact = <ServerContactsResponseModel>[];

    for (ServerContactsResponseModel contact in contacts) {
      if (contact.customerNumberPrimary.isNotEmpty) {
        if (contact.customerName.trim().isNotEmpty &&
            AppRegEx.checkEnglishLetter
                .hasMatch(contact.customerName.trim()[0])) {
          namedContact.add(contact);
        } else {
          unNamedContact.add(contact);
        }
      }
    }

    final contactList = <ServerContactListModel>[];

    if (namedContact.isNotEmpty) {
      final groupedByNamed = namedContact
          .groupListsBy<String>((ServerContactsResponseModel contact) {
        return contact.customerName[0].toUpperCase();
      });
      groupedByNamed.forEach((key, value) {
        contactList.add(
            ServerContactListModel(tag: key, contactDisplayDetails: value));
      });
    }

    if (unNamedContact.isNotEmpty) {
      contactList.add(ServerContactListModel(
          tag: AlphabeticList.unNamedSign,
          contactDisplayDetails: unNamedContact));
    }

    return contactList;
  }

  List<DeviceContactListModel> _groupByDevicesList(
      {required List<Contact> contacts}) {
    final namedContact = <Contact>[];

    final unNamedContact = <Contact>[];

    for (Contact contact in contacts) {
      if (contact.phones.isNotEmpty) {
        if (contact.displayName.trim().isNotEmpty &&
            AppRegEx.checkEnglishLetter
                .hasMatch(contact.displayName.trim()[0])) {
          namedContact.add(contact);
        } else {
          unNamedContact.add(contact);
        }
      }
    }

    final contactList = <DeviceContactListModel>[];

    if (namedContact.isNotEmpty) {
      final groupedByNamed =
          namedContact.groupListsBy<String>((Contact contact) {
        return contact.displayName[0].toUpperCase();
      });

      groupedByNamed.forEach((key, value) {
        contactList.add(DeviceContactListModel(
            tag: key,
            contactDisplayDetails: value.map((e) {
              return DeviceContactDisplayDetails(
                  id: e.id,
                  number: e.phones.first.number,
                  displayName: e.displayName,
                  thumbnail: e.thumbnail);
            }).toList()));
      });
    }
    if (unNamedContact.isNotEmpty) {
      contactList.add(DeviceContactListModel(
          tag: AlphabeticList.unNamedSign,
          contactDisplayDetails: unNamedContact.map((e) {
            return DeviceContactDisplayDetails(
                id: e.id,
                number: e.phones.first.number,
                thumbnail: e.thumbnail);
          }).toList()));
    }
    return contactList;
  }

  Future<void> searchContact({required String text}) async {
    final searchText = text.trim().toLowerCase();
    if (state is DeviceContactListState) {
      final currentState = state as DeviceContactListState;
      if (searchText.isEmpty) {
        emit(currentState.copyWith(searchList: () => null));
      } else {
        emit(currentState.copyWith(
            searchList: () => _searchedDeviceList(
                list: currentState.contactList, searchText: searchText)));
      }
    } else if (state is ServerContactListState) {
      final currentState = state as ServerContactListState;
      if (searchText.isEmpty) {
        emit(currentState.copyWith(searchList: () => null));
      } else {
        emit(currentState.copyWith(
            searchList: () => _searchedServerList(
                list: currentState.contactList, searchText: searchText)));
      }
    }
  }

  List<DeviceContactListModel> _searchedDeviceList({
    required List<DeviceContactListModel> list,
    required String searchText,
  }) {
    final searchedList = <DeviceContactListModel>[];
    List<DeviceContactDisplayDetails> filteredContacts = [];

    for (var contactList in list) {
      filteredContacts = [...contactList.contactDisplayDetails];
      for (var contact in contactList.contactDisplayDetails) {
        if (!("${contact.displayName} ${contact.number}")
            .trim()
            .toLowerCase()
            .contains(searchText)) {
          filteredContacts.remove(contact);
        }
      }
      searchedList
          .add(contactList.copyWidth(contactDisplayDetails: filteredContacts));
    }
    return searchedList;
  }

  List<ServerContactListModel> _searchedServerList({
    required List<ServerContactListModel> list,
    required String searchText,
  }) {
    final searchedList = <ServerContactListModel>[];
    List<ServerContactsResponseModel> filteredContacts = [];
    for (var contactList in list) {
      filteredContacts = [...contactList.contactDisplayDetails];
      for (var contact in contactList.contactDisplayDetails) {
        if (!("${contact.customerName} ${contact.customerNumberPrimary}")
            .trim()
            .toLowerCase()
            .contains(searchText)) {
          filteredContacts.remove(contact);
        }
      }
      searchedList
          .add(contactList.copyWidth(contactDisplayDetails: filteredContacts));
    }
    return searchedList;
  }

  void onChangeMenuSelection(int? value,
      {required String smeId, required BuildContext context}) {
    final previousSelectedMenu = state.selectedMenu;
    if (previousSelectedMenu == value) {
      return;
    }

    emit(state.parentCopyWith(selectedMenu: value));
    switch (value) {
      case 1:
        loadServerContacts(smeId: smeId);
        break;
      case 2:
        loadDeviceContacts(
            previousSelectedMenu: previousSelectedMenu, context: context);
        break;
    }
  }
}
