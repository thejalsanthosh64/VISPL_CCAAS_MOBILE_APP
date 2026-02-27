import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class AddNewContactButton extends StatelessWidget {
  const AddNewContactButton({
    super.key,
    this.onAddedNewContact,
  });

  final void Function(AddUpdateContactsRequestModel newContactDetails)?
      onAddedNewContact;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final newContactDetails = await Navigator.of(context)
            .pushNamed(AppRouteNames.addUpdateContact);
        if (newContactDetails is AddUpdateContactsRequestModel &&
            onAddedNewContact != null) {
          onAddedNewContact!(newContactDetails);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           AppSvgPicture(
            assetName: Assets.iconsAddNew,
            color: AppColors.appColor,
          ),
          const SizedBox(width: AppConstant.kSized15),
          Text(AppLocalizations.of(context)!.addNew),
        ],
      ),
    );
  }
}
