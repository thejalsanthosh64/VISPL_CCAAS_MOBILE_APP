import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_slidable_action.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/slidable_icon_button.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/call_manager/call_manager.dart';
import 'package:kommuno/features/contact/cubit/contact_list_cubit/contact_list_cubit.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/generated/assets.dart';
import 'alphabetic_list.dart';
import 'contact_list_tile.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class ServerAlphabeticList extends StatefulWidget {
  const ServerAlphabeticList({super.key,this.isPickerMode = false});
  final bool isPickerMode;

  @override
  State<ServerAlphabeticList> createState() => _ServerAlphabeticListState();
}

class _ServerAlphabeticListState extends State<ServerAlphabeticList>
    with TickerProviderStateMixin {
  ContactListCubit get _contactListCubit => context.read<ContactListCubit>();

  late UserDetailsModel _userDetails;

final Map<String, SlidableController> _slidableControllers = {};

  @override
  void initState() {
    super.initState();
    _userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    _contactListCubit.paginationScrollController.init(loadAction: () {
      if (_contactListCubit.state is ServerContactListState &&
          (_contactListCubit.state as ServerContactListState).searchList ==
              null) {
        return _contactListCubit.loadServerContacts(
            isLoading: false, smeId: "${_userDetails.smeId}");
      }
      return Future.value(
          _contactListCubit.paginationScrollController.hasMoreData);
    });
  }

  @override
  void dispose() {
    _slidableControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactListCubit, ContactListState>(
      builder: (__, state) {
        if (state is ServerContactListState) {
          final contactList =
              state.searchList != null ? state.searchList! : state.contactList;
          if (contactList
              .map((e) => e.contactDisplayDetails.isEmpty)
              .every((e) => e == true)) {
            return EmptyErrorWidget(
              showButton: state.searchList == null,
              text: AppLocalizations.of(context)!.noRecordFound,
              onTap: () {
                _contactListCubit.loadServerContacts(
                    initialRecordValue: 1,
                    isLoading: false,
                    smeId: "${_userDetails.smeId}");
              },
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _contactListCubit.loadServerContacts(
                    initialRecordValue: 1,
                    isLoading: false,
                    smeId: "${_userDetails.smeId}");
              },
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: false,
                child: AlphabeticList(
                  scrollController: _contactListCubit
                      .paginationScrollController.scrollController,
                  items: List<AlphabetListViewItemGroup>.generate(
                    contactList.length,
                    (contactListIndex) {
                      return AlphabetListViewItemGroup(
                        tag: contactList[contactListIndex].tag,
                        children: List<Widget>.generate(
                          contactList[contactListIndex]
                              .contactDisplayDetails
                              .length,
                          (index) {
                            final contact = contactList[contactListIndex]
                                .contactDisplayDetails[index];
                            if (_slidableControllers[contact.id] == null) {
                              _slidableControllers[contact.id] =
                                  SlidableController(this);
                            }
                            return Slidable(
                              controller: _slidableControllers[contact.id],
                              key: ValueKey<String>(
                                  "ServerAlphabeticList_Slidable_${index}_${contact.id}"),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.40,
                                children: [
                                  AppSlidableAction(
                                    onPressed: (__) {
                                      Navigator.of(context).pushNamed(
                                          AppRouteNames.addScheduleCall,
                                          arguments: {
                                            "number":
                                                contact.customerNumberPrimary,
                                            "customerName": contact.customerName
                                          });
                                    },
                                    backgroundColor: AppColors.green,
                                    text:
                                        AppLocalizations.of(context)!.schedule,
                                    iconName: Assets.iconsSchedule,
                                  ),
                                  AppSlidableAction(
                                    onPressed: (__) async {
                                      final updatedContactDetails =
                                          await Navigator.of(context).pushNamed(
                                              AppRouteNames.addUpdateContact,
                                              arguments: {
                                            "updateContactDetails":
                                                AddUpdateContactsRequestModel(
                                              customerNumber:
                                                  contact.customerNumberPrimary,
                                              customerName:
                                                  contact.customerName,
                                              customerNumberSecondary: [
                                                contact.customerNumberSecondary
                                              ],
                                              addressBookId:
                                                  AddUpdateContactsRequestModel
                                                      .defaultAddressBookId,
                                              agentNumber:
                                                  _userDetails.agentMobile,
                                              companyName: contact.companyName,
                                              createdBy: contact.createdBy,
                                              emailId: contact.emailId,
                                              mode: "${contact.mode}",
                                              insertDateTime:
                                                  contact.insertDateTime,
                                              updatedDateTime:
                                                  contact.updatedDateTime,
                                              visibilityFlag:
                                                  "${contact.visibilityFlag}",
                                              smeId: "${contact.smeId}",
                                            )
                                          });

                                      if (updatedContactDetails
                                          is AddUpdateContactsRequestModel) {
                                        _contactListCubit.loadServerContacts(
                                            isLoading: false,
                                            initialRecordValue: 1,
                                            smeId: "${_userDetails.smeId}");
                                      }
                                    },
                                    backgroundColor: AppColors.appColor,
                                    text: AppLocalizations.of(context)!.update,
                                    iconName: Assets.iconsSettings,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap:widget.isPickerMode? () => Navigator.pop(context, contact): null,
                                child: ContactListTile(
                                  customerName: contact.customerName,
                                  customerNo: contact.customerNumberPrimary,
                                  
                                  trailing: [
                                    SlidableIconButton(
                                      slidableController:
                                          _slidableControllers[contact.id]!,
                                    ),
                                  ],
                                  onTapPhone: () {
                                    CallManager.makeNewCall(
                                        number: contact.customerNumberPrimary);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
