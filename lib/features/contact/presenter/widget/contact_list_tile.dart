import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_icon_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/contact/presenter/widget/alphabetic_list.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.customerNo,
    this.onTapPhone,
    this.customerName,
    this.thumbnail,
    this.trailing = const [],
  });

  final String? customerName;
  final String customerNo;
  final VoidCallback? onTapPhone;
  final Uint8List? thumbnail;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final checkCustomerName = (customerName ?? '').trim().isNotEmpty;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: AppAvatar(
        backgroundImage: thumbnail != null ? MemoryImage(thumbnail!) : null,
        child: thumbnail == null
            ? Text(
                checkCustomerName &&
                        int.tryParse(customerName!.trim()[0]) == null
                    ? customerName!.capitalizeFirstLetterOfTwoWords
                    : AlphabeticList.unNamedSign,
                style: AppTextStyle.white16,
              )
            : null,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(
            onTap: onTapPhone,
            icon: const Icon(Icons.phone, color: AppColors.appColor),
          ),
          ...trailing
        ],
      ),
      dense: true,
      title: Text(
          checkCustomerName
              ? customerName!
              : addByIndiaCountryCodeWithoutPlus(number: customerNo),
          style: AppTextStyle.appColor18),
      subtitle: checkCustomerName
          ? Text(addByIndiaCountryCodeWithoutPlus(number: customerNo),
              style: AppTextStyle.blackNormal)
          : null,
    );
  }
}
