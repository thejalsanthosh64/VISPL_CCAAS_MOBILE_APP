import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/features/contact/data/model/device_contact_list_model.dart';
import 'alphabetic_list.dart';
import 'contact_list_tile.dart';

class DeviceAlphabeticList extends StatelessWidget {
  const DeviceAlphabeticList({
    super.key,
    required this.contactList,
    this.onTapPhone,
    required this.onRefresh,
  });

  final List<DeviceContactListModel> contactList;

  final Future<void> Function() onRefresh;

  final void Function(DeviceContactDisplayDetails contactDisplayDetails)?
      onTapPhone;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AlphabeticList(
        items: List<AlphabetListViewItemGroup>.generate(
          contactList.length,
          (contactListIndex) {
            return AlphabetListViewItemGroup(
              tag: contactList[contactListIndex].tag,
              children: List<Widget>.generate(
                contactList[contactListIndex].contactDisplayDetails.length,
                (index) {
                  final contact = contactList[contactListIndex]
                      .contactDisplayDetails[index];
                  return ContactListTile(
                    customerName: contact.displayName,
                    customerNo: contact.number,
                    thumbnail: contact.thumbnail,
                    onTapPhone: () {
                      if (onTapPhone != null) {
                        onTapPhone!(contact);
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
