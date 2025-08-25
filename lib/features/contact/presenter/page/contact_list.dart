import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/add_new_contact_button.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';

import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/search_field.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/call_manager/call_manager.dart';
import 'package:kommuno/features/contact/cubit/contact_list_cubit/contact_list_cubit.dart';
import 'package:kommuno/features/contact/presenter/widget/device_alphabetic_list.dart';
import 'package:kommuno/features/contact/presenter/widget/server_alphabetic_list.dart';
import 'package:kommuno/generated/assets.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    return BlocProvider(
      create: (context) => ContactListCubit(),
      child: _ContactListState(userDetails: userDetails),
    );
  }
}

class _ContactListState extends StatelessWidget {
  const _ContactListState({required this.userDetails});

  final UserDetailsModel userDetails;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  ContactListCubit _contactListCubit(BuildContext context) =>
      context.read<ContactListCubit>();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        floatingActionButton: const AppShortcutButton(),
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.contacts,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ContactListCubit, ContactListState>(
      builder: (context, state) {
        if (state is ContactListInitial) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _contactListCubit(context)
                    .loadServerContacts(smeId: "${userDetails.smeId}");
              }
            },
          );
          return const SizedBox();
        } else if (state is ContactListLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is ContactListErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              if (state.selectedMenu == 1) {
                _contactListCubit(context)
                    .loadServerContacts(smeId: "${userDetails.smeId}");
              } else {
                _contactListCubit(context).loadDeviceContacts(
                    context: context, previousSelectedMenu: state.selectedMenu);
              }
            },
          );
        } else {
          return Column(
            children: [
              _kSized10,
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.kBodyHorizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: AddNewContactButton(
                        onAddedNewContact: (newContactDetails) {
                          if (state is ServerContactListState) {
                            _contactListCubit(context).loadServerContacts(
                                smeId: "${userDetails.smeId}",
                                initialRecordValue: 1,
                                isLoading: false);
                          }
                        },
                      ),
                    ),
                    if ((state is ServerContactListState &&
                            state.contactList.isEmpty) ||
                        (state is DeviceContactListState &&
                            state.contactList.isEmpty))
                      _buildTogglePopup(context: context, state: state)
                  ],
                ),
              ),
              if ((state is ServerContactListState &&
                      state.contactList.isNotEmpty) ||
                  (state is DeviceContactListState &&
                      state.contactList.isNotEmpty)) ...[
                _kSized10,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.kBodyHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(
                          onChanged: (text) {
                            _contactListCubit(context).debouncer.run(() {
                              _contactListCubit(context)
                                  .searchContact(text: text);
                            });
                          },
                        ),
                      ),
                      _kSized15,
                      _buildTogglePopup(context: context, state: state),
                    ],
                  ),
                ),
              ],
              _kSized10,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: AppConstant.kBodyHorizontalPadding),
                  child: _buildContactList(state: state, context: context),
                ),
              ),
              _kSized15,
            ],
          );
        }
      },
    );
  }

  Widget _buildContactList(
      {required ContactListState state, required BuildContext context}) {
    if (state is DeviceContactListState) {
      final contactList =
          state.searchList != null ? state.searchList! : state.contactList;
      if (contactList
          .map((e) => e.contactDisplayDetails.isEmpty)
          .every((e) => e == true)) {
        return EmptyErrorWidget(
          showButton: state.searchList == null,
          text: AppLocalizations.of(context)!.noRecordFound,
          onTap: () {
            _contactListCubit(context).loadDeviceContacts(
                context: context,
                previousSelectedMenu: state.selectedMenu,
                isLoading: false);
          },
        );
      } else {
        return DeviceAlphabeticList(
          onRefresh: () async {
            _contactListCubit(context).loadDeviceContacts(
                context: context,
                previousSelectedMenu: state.selectedMenu,
                isLoading: false);
          },
          contactList: contactList,
          onTapPhone: (contact) {
            _onTapPhone(number: contact.number);
          },
        );
      }
    } else if (state is ServerContactListState) {
      return const ServerAlphabeticList();
    }
    return const SizedBox();
  }

  Future<void> _onTapPhone({required String number}) async {
    CallManager.makeNewCall(number: number);
  }

  PopupMenuItem<int> _buildMenuItem({
    required int value,
    required String text,
    required int selectedMenu,
    required String iconName,
  }) {
    return PopupMenuItem<int>(
      value: value,
      padding: EdgeInsets.zero,
      height: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color:
            selectedMenu == value ? AppColors.appColor : AppColors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvgPicture(
              assetName: iconName,
              color:
                  selectedMenu == value ? AppColors.white : AppColors.appColor,
            ),
            const SizedBox(width: AppConstant.kSized10),
            Expanded(
              child: Text(
                text,
                style: selectedMenu == value
                    ? AppTextStyle.whiteNormal
                    : AppTextStyle.blackNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTogglePopup(
      {required BuildContext context, required ContactListState state}) {
    return PopupMenuButton<int>(
      initialValue: state.selectedMenu,
      onSelected: (value) {
        _contactListCubit(context).onChangeMenuSelection(value,
            smeId: "${userDetails.smeId}", context: context);
      },
      padding: EdgeInsets.zero,
      itemBuilder: (__) {
        return [
          _buildMenuItem(
              value: 1,
              text: AppLocalizations.of(context)!.accountContacts,
              selectedMenu: state.selectedMenu,
              iconName: Assets.iconsAccountContacts),
          _buildMenuItem(
              value: 2,
              text: AppLocalizations.of(context)!.phoneContacts,
              selectedMenu: state.selectedMenu,
              iconName: Assets.iconsPhoneContacts),
        ];
      },
      child: const Icon(
        Icons.menu,
        color: AppColors.appColor,
      ),
    );
  }
}
