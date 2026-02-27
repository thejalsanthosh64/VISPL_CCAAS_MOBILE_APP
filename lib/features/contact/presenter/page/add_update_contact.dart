import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/common/widget/app_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/mobile_textfield.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/contact/cubit/add_update_contact/add_update_contact_cubit.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';

class AddUpdateContact extends StatelessWidget {
  const AddUpdateContact({super.key});

  @override
  Widget build(BuildContext context) {
    AddUpdateContactsRequestModel? updateContactDetails;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args?["updateContactDetails"] is AddUpdateContactsRequestModel) {
      updateContactDetails = args!["updateContactDetails"]!;
    }
    return BlocProvider(
      create: (__) =>
          AddUpdateContactCubit(updateContactDetails: updateContactDetails),
      child: _AddUpdateContactState(updateContactDetails: updateContactDetails),
    );
  }
}

class _AddUpdateContactState extends StatelessWidget {
  const _AddUpdateContactState({this.updateContactDetails});

  final AddUpdateContactsRequestModel? updateContactDetails;

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        appBar: MyAppBar(
          title: updateContactDetails != null
              ? AppLocalizations.of(context)!.updateContact
              : AppLocalizations.of(context)!.createNewContact,
          actions: [
            BreakInButton.outline(),
            const SizedBox(width: AppConstant.kSized10)
          ],
        ),
        body: _buildForm(context),
      ),
    );
  }

  SizedBox get _kSized20 => const SizedBox(height: AppConstant.kSized20);

  AddUpdateContactCubit _addUpdateContactCubit(BuildContext context) =>
      context.read<AddUpdateContactCubit>();

  Widget _buildForm(BuildContext context ) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.kBodyHorizontalPadding),
        child: BlocConsumer<AddUpdateContactCubit, AddUpdateContactState>(
            listener: (context, state) {
          if (state.addNewContactDetails != null) {
            Navigator.of(context).pop(state.addNewContactDetails);
          }
        }, builder: (context, state) {
          return Column(
            children: [
              _kSized20,
              AppAvatar(
                radius: 30,
                child: state.customerName.trim().isNotEmpty
                    ? Text(
                        state.customerName.capitalizeFirstLetterOfTwoWords,
                        style: AppTextStyle.white23,
                      )
                    : const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 40,
                      ),
              ),
              _kSized20,
              AppTextField(
                controller:
                    _addUpdateContactCubit(context).customerNameController,
                hintText: AppLocalizations.of(context)!.name,
                textInputAction: TextInputAction.next,
                onChanged: (text) {
                  _addUpdateContactCubit(context).debouncer.run(() {
                    _addUpdateContactCubit(context)
                        .changeAvatarState(text: text);
                  });
                },
                prefixIcon:  Icon(
                  Icons.person,
                  color: AppColors.appColor,
                ),
              ),
              _kSized20,
              MobileTextField(
                controller:
                    _addUpdateContactCubit(context).customerMobileController,
                textInputAction: TextInputAction.next,
                readOnly: updateContactDetails != null,
              ),
              _kSized20,
              AppTextField(
                hintText: AppLocalizations.of(context)!.companyName,
                controller:
                    _addUpdateContactCubit(context).companyNameController,
                textInputAction: TextInputAction.next,
                prefixIcon:  Icon(
                  Icons.apartment_sharp,
                  color: AppColors.appColor,
                ),
              ),
              _kSized20,
              AppTextField(
                hintText: AppLocalizations.of(context)!.enterEmail,
                controller: _addUpdateContactCubit(context).emailIdController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon:  Icon(
                  Icons.email,
                  color: AppColors.appColor,
                ),
              ),
              _kSized20,
              AppButton(
                text: updateContactDetails != null
                    ? AppLocalizations.of(context)!.update
                    : AppLocalizations.of(context)!.save,
                onTap: () {
                  if (updateContactDetails != null) {
                    final localUpdateContactDetails = updateContactDetails!
                        .copyWith(
                            customerNumber: _addUpdateContactCubit(context)
                                .customerMobileController
                                .text,
                            customerName: _addUpdateContactCubit(context)
                                .customerNameController
                                .text,
                            companyName: _addUpdateContactCubit(context)
                                .companyNameController
                                .text,
                            emailId: _addUpdateContactCubit(context)
                                .emailIdController
                                .text,
                            updatedDateTime: DateTime.now());
                    _addUpdateContactCubit(context).updateContact(
                        addNewContactDetails: localUpdateContactDetails,userDetails: userDetails);
                  } else {
                    final userDetails =
                        context.read<UserDetailsCubit>().userDetailsModel;
                    final now = DateTime.now();
                    final addNewContactDetails = AddUpdateContactsRequestModel(
                      smeId: "${userDetails.smeId}",
                      customerNumber: _addUpdateContactCubit(context)
                          .customerMobileController
                          .text,
                      customerName: _addUpdateContactCubit(context)
                          .customerNameController
                          .text,
                      agentNumber: userDetails.agentMobile,
                      companyName: _addUpdateContactCubit(context)
                          .companyNameController
                          .text,
                      createdBy:
                          UserLoginInfoManager.userLoginInfoModel!.userId,
                      emailId: _addUpdateContactCubit(context)
                          .emailIdController
                          .text,
                      insertDateTime: now,
                      updatedDateTime: now,
                    );
                    print("📤 ADD CONTACT BODY → ${addNewContactDetails.toJson()}");

                    _addUpdateContactCubit(context).addNewContact(
                        addNewContactDetails: addNewContactDetails, userDetails: userDetails);
                  }
                },
              ),
              _kSized20,
            ],
          );
        }),
      ),
    );
  }
}
