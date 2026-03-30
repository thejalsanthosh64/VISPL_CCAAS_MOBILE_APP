import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_slidable_action.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/common/widget/make_call_button.dart';
import 'package:kommuno/core/common/widget/slidable_icon_button.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/whatsapp_launcher_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/audio_player_2/widget/app_audio_player.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/features/contact/data/model/server_contact_response_model.dart';
import 'package:kommuno/features/contact/presenter/widget/contact_helper.dart';
import 'package:kommuno/features/recent_calls/cubit/recent_calls_cubit/recent_calls_cubit.dart';
import 'package:kommuno/features/recent_calls/data/enum/call_direction_enum.dart';
import 'package:kommuno/features/recent_calls/data/model/request/recent_calls_request_model.dart';
import 'package:kommuno/features/recent_calls/data/model/response/recent_calls_data.dart';
import 'package:kommuno/features/recent_calls/data/repository/recent_calls_repo.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_required_fields_model.dart';
import 'package:kommuno/generated/assets.dart';

class RecentCallsListTile extends StatelessWidget {
  const RecentCallsListTile({
    super.key,
    required this.index,
    required this.slidableController,
    required this.recentCallsData,
    this.recentCallsRequestModel,
  });

  final int index;
  final SlidableController slidableController;
  final RecentCallsData recentCallsData;
  final List<RecentCallsRequestModel>? recentCallsRequestModel;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  RecentCallsCubit _recentCallsCubit(BuildContext context) =>
      context.read<RecentCallsCubit>();

  @override
  Widget build(BuildContext context) {
    
final String rawNumber = recentCallsData.customerNumber;
    final contact = ContactLookup.getContact(rawNumber);

    // Use synced contact name > API name > Fallback to formatted number
    final String resolvedDisplayName = (contact?.customerName?.isNotEmpty ?? false)
        ? contact!.customerName
        : (recentCallsData.customerName?.isNotEmpty ?? false)
            ? recentCallsData.customerName!
            : addByIndiaCountryCodeWithoutPlus(number: rawNumber);

    // Check if the name we found is different from the raw number (to decide if we show the number row)
    final bool hasName = resolvedDisplayName != addByIndiaCountryCodeWithoutPlus(number: rawNumber);
    return Slidable(
      controller: slidableController,
      key: ValueKey<String>(
          "RecentCallsList_RecentCallsListTile_Slidable_${index}_${recentCallsData.id}"),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context)
                  .pushNamed(AppRouteNames.remarks, arguments: {
                "remarks_required_fields": RemarksRequiredFieldsModel(
                  customerNumber: recentCallsData.customerNumber,
                  sessionId: recentCallsData.sessionId,
                  callDirection: recentCallsData.callDirection,
                  customerName: recentCallsData.customerName,
                )
              });
            },
            backgroundColor: AppColors.orange,
            text: AppLocalizations.of(context)!.remarks,
            iconName: Assets.iconsEdit,
          ),
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context).pushNamed(
                AppRouteNames.addScheduleCall,
                arguments: {
                  "number": recentCallsData.customerNumber,
                  "customerName": recentCallsData.customerName
                },
              );
            },
            backgroundColor: AppColors.green,
            text: AppLocalizations.of(context)!.schedule,
            iconName: Assets.iconsSchedule,
          ),
//           AppSlidableAction(
//             onPressed: (__) async {
//               final userDetailsModel =
//                   context.read<UserDetailsCubit>().userDetailsModel;
// final syncDetails = ContactLookup.getContact(recentCallsData.customerNumber);
              
//                    final updatedContactDetails = await Navigator.of(context)
//                   .pushNamed(AppRouteNames.addUpdateContact, arguments: {
//                 "updateContactDetails": AddUpdateContactsRequestModel(
//                   customerName: recentCallsData.customerName ?? '',
//                   customerNumber: recentCallsData.customerNumber,
//                   addressBookId:
//                       AddUpdateContactsRequestModel.defaultAddressBookId,
//                   agentNumber: userDetailsModel.agentMobile,
//                     companyName: syncDetails?.companyName ?? '',         
//                   createdBy: userDetailsModel.agentId,
// emailId: syncDetails?.emailId ?? '',                  insertDateTime: recentCallsData.insertDateTime,
//                   updatedDateTime: DateTime.now(),
//                   smeId: "${userDetailsModel.smeId}",
//                 )
//               });
//              if (context.mounted && updatedContactDetails is AddUpdateContactsRequestModel) {
//       // ✅ 1. INSTANT LOCAL UPDATE (This makes the name change immediately)
//       final norm = ContactLookup.normalize(updatedContactDetails.customerNumber);
//       ContactLookup.serverNames[norm] = updatedContactDetails.customerName;
      
//       // ✅ 2. SYNC IN BACKGROUND
//       ContactSync().refresh(
//         context: context,
//         smeId: userDetailsModel.smeId.toString(),
//         agentId: userDetailsModel.agentId,
//       );

//       // ✅ 3. REFRESH LIST
//       _recentCallsCubit(context).getRecentCalls(
//         smeId: userDetailsModel.smeId,
//         initialRecordValue: 1,
//         isLoading: false,
//         agentId: userDetailsModel.agentId
//       );
//     }
//             },
//             backgroundColor: AppColors.appColor,
//             text: AppLocalizations.of(context)!.update,
//             iconName: Assets.iconsSettings,
//           ),

// AppSlidableAction(
//   onPressed: (__) async {
//     final userDetailsModel = context.read<UserDetailsCubit>().userDetailsModel;
//     final syncDetails = ContactLookup.getContact(recentCallsData.customerNumber);
    
//     final updatedContactDetails = await Navigator.of(context).pushNamed(
//       AppRouteNames.addUpdateContact, 
//       arguments: {
//         "updateContactDetails": AddUpdateContactsRequestModel(
//           // Use the resolved name so it's pre-filled correctly
//           customerName: resolvedDisplayName, 
//           customerNumber: recentCallsData.customerNumber,
//           agentNumber: userDetailsModel.agentMobile,
//           companyName: syncDetails?.companyName ?? '',
//           emailId: syncDetails?.emailId ?? '',
//           createdBy: userDetailsModel.agentId,
//           insertDateTime: recentCallsData.insertDateTime,
//           updatedDateTime: DateTime.now(),
//           smeId: "${userDetailsModel.smeId}",
//         )
//       }
//     );

//     if (context.mounted && updatedContactDetails is AddUpdateContactsRequestModel) {
//       final norm = ContactLookup.normalize(updatedContactDetails.customerNumber);
      
//       // ✅ 1. MANUALLY UPDATE BOTH MAPS IMMEDIATELY
//       ContactLookup.serverNames[norm] = updatedContactDetails.customerName;
//       ContactLookup.serverContacts[norm] = ServerContactsResponseModel(
//         id: syncDetails?.id ?? '', // Keep existing ID
//         smeId: userDetailsModel.smeId,
//         customerName: updatedContactDetails.customerName,
//         customerNumberPrimary: updatedContactDetails.customerNumber,
//         mode: syncDetails?.mode ?? 0,
//         customerNumberSecondary: syncDetails?.customerNumberSecondary ?? '',
//         companyName: updatedContactDetails.companyName,
//         emailId: updatedContactDetails.emailId,
//         address: syncDetails?.address ?? '',
//         createdBy: userDetailsModel.agentId,
//         visibilityFlag: syncDetails?.visibilityFlag ?? '',
//         insertDateTime: syncDetails?.insertDateTime ?? DateTime.now(),
//         updatedDateTime: DateTime.now(),
//         isUpdated: 1,
//       );

//       // 2. Trigger sync in background
//       ContactSync().refresh(
//         context: context,
//         smeId: userDetailsModel.smeId.toString(),
//         agentId: userDetailsModel.agentId,
//       );

//       // 3. Refresh list
//       _recentCallsCubit(context).getRecentCalls(
//         smeId: userDetailsModel.smeId,
//         initialRecordValue: 1,
//         isLoading: false,
//         agentId: userDetailsModel.agentId
//       );
//     }
//   },
//   backgroundColor: AppColors.appColor,
//   text: AppLocalizations.of(context)!.update,
//   iconName: Assets.iconsSettings,
// ),

// AppSlidableAction(
//   onPressed: (__) async {
//     final userDetailsModel = context.read<UserDetailsCubit>().userDetailsModel;
//     final syncDetails = ContactLookup.getContact(recentCallsData.customerNumber);
    
//     final updatedContactDetails = await Navigator.of(context).pushNamed(
//       AppRouteNames.addUpdateContact, 
//       arguments: {
//         "updateContactDetails": AddUpdateContactsRequestModel(
//           customerName: resolvedDisplayName, 
//           customerNumber: recentCallsData.customerNumber,
//           agentNumber: userDetailsModel.agentMobile,
//           companyName: syncDetails?.companyName ?? '',
//           emailId: syncDetails?.emailId ?? '',
//           createdBy: userDetailsModel.agentId,
//           insertDateTime: recentCallsData.insertDateTime,
//           updatedDateTime: DateTime.now(),
//           smeId: "${userDetailsModel.smeId}",
//         )
//       }
//     );

//     if (context.mounted && updatedContactDetails is AddUpdateContactsRequestModel) {
//       // ✅ 1. MANUAL LOCAL UPDATE (Crucial for instant reflection)
//       final String norm = ContactLookup.normalize(updatedContactDetails.customerNumber);
      
//       // Update the name map used by resolvedDisplayName
//       ContactLookup.serverNames[norm] = updatedContactDetails.customerName;
      
//       // Update the full model map used by pre-filling
//       ContactLookup.serverContacts[norm] = ServerContactsResponseModel(
//         id: syncDetails?.id ?? '', 
//         smeId: userDetailsModel.smeId,
//         customerName: updatedContactDetails.customerName,
//         customerNumberPrimary: updatedContactDetails.customerNumber,
//         mode: syncDetails?.mode ?? 0,
//         customerNumberSecondary: syncDetails?.customerNumberSecondary ?? '',
//         companyName: updatedContactDetails.companyName,
//         emailId: updatedContactDetails.emailId,
//         address: syncDetails?.address ?? '',
//         createdBy: userDetailsModel.agentId,
//         visibilityFlag: syncDetails?.visibilityFlag ?? '',
//         insertDateTime: syncDetails?.insertDateTime ?? DateTime.now(),
//         updatedDateTime: DateTime.now(),
//         isUpdated: 1,
//       );

//       // 2. Trigger background sync to keep everything consistent
//       ContactSync().refresh(
//         context: context,
//         smeId: userDetailsModel.smeId.toString(),
//         agentId: userDetailsModel.agentId,
//       );

//       // 3. Refresh the List UI
//       // We pass initialRecordValue: 1 to reset the list
//       _recentCallsCubit(context).getRecentCalls(
//         smeId: userDetailsModel.smeId,
//         initialRecordValue: 1,
//         isLoading: false,
//         agentId: userDetailsModel.agentId
//       );
//     }
//   },
//   backgroundColor: AppColors.appColor,
//   text: AppLocalizations.of(context)!.update,
//   iconName: Assets.iconsSettings,
// ),

AppSlidableAction(
  onPressed: (__) async {
    final userDetailsModel = context.read<UserDetailsCubit>().userDetailsModel;
    final syncDetails = ContactLookup.getContact(recentCallsData.customerNumber);
    
    debugPrint("🚀 [DEBUG] Opening Update Screen for: ${recentCallsData.customerNumber}");

    final updatedContactDetails = await Navigator.of(context).pushNamed(
      AppRouteNames.addUpdateContact, 
      arguments: {
        "updateContactDetails": AddUpdateContactsRequestModel(
          customerName: resolvedDisplayName, 
          customerNumber: recentCallsData.customerNumber,
          agentNumber: userDetailsModel.agentMobile,
          companyName: syncDetails?.companyName ?? '',
          emailId: syncDetails?.emailId ?? '',
          createdBy: userDetailsModel.agentId,
          insertDateTime: recentCallsData.insertDateTime,
          updatedDateTime: DateTime.now(),
          smeId: "${userDetailsModel.smeId}",
        )
      }
    );

   if (context.mounted && updatedContactDetails is AddUpdateContactsRequestModel) {
  final norm = ContactLookup.normalize(updatedContactDetails.customerNumber);

  // Update BOTH maps immediately
  ContactLookup.serverNames[norm] = updatedContactDetails.customerName;
  
  final existing = ContactLookup.serverContacts[norm];
  ContactLookup.serverContacts[norm] = ServerContactsResponseModel(
    id: existing?.id ?? '',
    smeId: userDetailsModel.smeId,
    customerName: updatedContactDetails.customerName,
    customerNumberPrimary: updatedContactDetails.customerNumber,
    mode: existing?.mode ?? 0,
    customerNumberSecondary: existing?.customerNumberSecondary ?? '',
    companyName: updatedContactDetails.companyName,
    emailId: updatedContactDetails.emailId,
    address: existing?.address ?? '',
    createdBy: userDetailsModel.agentId,
    visibilityFlag: existing?.visibilityFlag ?? '',
    insertDateTime: existing?.insertDateTime ?? DateTime.now(),
    updatedDateTime: DateTime.now(),
    isUpdated: 1,
  );

  // Update cubit state
  final cubit = context.read<RecentCallsCubit>();
  cubit.refreshSingleContact(
    customerNumber: updatedContactDetails.customerNumber,
    newName: updatedContactDetails.customerName,
  );

  // DO NOT call ContactSync().refresh() — it overwrites with stale API data
}
  },
  backgroundColor: AppColors.appColor,
  text: AppLocalizations.of(context)!.update,
  iconName: Assets.iconsSettings,
),
        ],
      ),
      child: ColoredBox(
        color: index.isOdd ? AppColors.white : AppColors.whiteGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: AppConstant.kBodyHorizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30,
                      child: recentCallsData.callDirection ==
                              CallDirectionEnum.incoming.value
                          ? const AppSvgPicture(
                              assetName: Assets.iconsIncomingCallArrow,
                            )
                          : const AppSvgPicture(
                              assetName: Assets.iconsOutgoingCallArrow,
                            ),
                    ),
                    _kSized10,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          
                          // FittedBox(
                          //   child: Text(
                          //     (recentCallsData.customerName ?? '')
                          //             .trim()
                          //             .isEmpty
                          //         ? addByIndiaCountryCodeWithoutPlus(
                          //             number: recentCallsData.customerNumber)
                          //         : recentCallsData.customerName ??
                          //             addByIndiaCountryCodeWithoutPlus(
                          //                 number:
                          //                     recentCallsData.customerNumber),
                          //     style: AppTextStyle.black16,
                          //     maxLines: 1,
                          //   ),
                          // ),
                          // if ((recentCallsData.customerName ?? '')
                          //     .trim()
                          //     .isNotEmpty)
                          //   FittedBox(
                          //     child: Text(
                          //       addByIndiaCountryCodeWithoutPlus(
                          //           number: recentCallsData.customerNumber),
                          //       style: AppTextStyle.blackNormal,
                          //       maxLines: 1,
                          //     ),
                          //   ),
                          // FittedBox(
                          //   child: Text(
                          //     DateUtility.getDisplayDateTimeWithMonthName(
                          //         date: recentCallsData.insertDateTime),
                          //     style: AppTextStyle.grey13,
                          //   ),
                          // ),

                          FittedBox(
                            child: Text(
                              resolvedDisplayName, // ✅ Use the resolved name here
                              style: AppTextStyle.black16,
                              maxLines: 1,
                            ),
                          ),
                          // Only show the number row if we actually found a name above
                          if (hasName)
                            FittedBox(
                              child: Text(
                                addByIndiaCountryCodeWithoutPlus(number: recentCallsData.customerNumber),
                                style: AppTextStyle.blackNormal,
                                maxLines: 1,
                              ),
                            ),
                          FittedBox(
                            child: Text(
                              DateUtility.getDisplayDateTimeWithMonthName(date: recentCallsData.insertDateTime),
                              style: AppTextStyle.grey13,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              _kSized5,
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if ((recentCallsData.recordingPath ?? '').isNotEmpty) {
                    appDialog(
                        constraints: const BoxConstraints(
                            minHeight: 200, maxHeight: 200),
                        context: context,
                        customBody: AppAudioPlayer1(
                          audioUrl: recentCallsData.recordingPath!,
                        ));
                  }
                },
                child: AppAvatar(
                  radius: 15,
                  backgroundColor: (recentCallsData.recordingPath ?? '').isEmpty
                      ? AppColors.grey
                      : AppColors.appColor,
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 25,
                  ),
                ),
              ),
              _kSized5,

          IconButton(
  padding: EdgeInsets.zero,
  constraints: const BoxConstraints(),
  visualDensity: VisualDensity.compact,
  icon: const FaIcon(FontAwesomeIcons.message, size: 20),
  color: AppColors.appColor,
  onPressed: () {
    _openTemplateSheet(
      context,
      type: "sms",
    );
  },
),


IconButton(
  padding: EdgeInsets.zero,
  constraints: const BoxConstraints(),
  visualDensity: VisualDensity.compact,
  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 23),
  color: Colors.green,
  onPressed: () {
    _openTemplateSheet(
      context,
      type: "whatsapp",
    );
  },
),




              // WhatsappLauncherButton(
              //   number: recentCallsData.customerNumber,
              //   radius: 15,
              // ),
              _kSized5,
              MakeCallButton(
                number: recentCallsData.customerNumber,
                radius: 15,
                backgroundColor: AppColors.green,
              ),
              SlidableIconButton(slidableController: slidableController),
            ],
          ),
        ),
      ),
    );
  }

  void _openTemplateSheet(
  BuildContext context, {
  required String type,
}) async {
  final cubit = context.read<RecentCallsCubit>();
  final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;

  try {
    final templates = type == "sms"
        ? await cubit.loadSmsTemplates(smeId)
        : await cubit.loadWhatsappTemplates(smeId);

    if (templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No templates found")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: templates.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final template = templates[index];

            return ListTile(
              title: Text(
                type == "sms"
                    ? template["template_name"] ?? ""
                    : template["name"] ?? "",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);

                if (type == "sms") {
                  _openPreviewSheet(
                    context,
                    template: template,
                    
                  );
                } else {
                  _sendWhatsapp(template, context);
                }
              },
            );
          },
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to load templates")),
    );
  }
}

void _openPreviewSheet(
  BuildContext context, {
  required Map<String, dynamic> template,
}) {
  final cubit = context.read<RecentCallsCubit>();
  final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;

  final TextEditingController controller =
      TextEditingController(text: template["message"] ?? "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.45,
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Preview Message"),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const Divider(),

              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: "Edit message",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                  child: const Text("Send",style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),),
                  onPressed: () async {
              final body = _buildPayloadFromRecentCall(
  call: recentCallsData,
  template: template,
  isWhatsapp: false,
)..["message"] = controller.text.trim();   

debugPrint(" SMS PAYLOAD => $body");

await cubit.sendSms(
  smeId: smeId,
  body: body,
);


                    Navigator.pop(sheetContext);

                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Future<void> _sendWhatsapp(
  Map<String, dynamic> template,
  BuildContext context,
) async {
  final cubit = context.read<RecentCallsCubit>();
  final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;

  final body = _buildPayloadFromRecentCall(
    call: recentCallsData,
    template: template,
    isWhatsapp: true,
  );

  debugPrint("WHATSAPP PAYLOAD => $body");

  await cubit.sendWhatsapp(
    smeId: smeId,
    body: body,
  );

}

Map<String, dynamic> _buildPayloadFromRecentCall({
  required RecentCallsData call,
  required Map<String, dynamic> template,
  required bool isWhatsapp,
}) {
  return {
    "templateId": template["id"],
    "message": isWhatsapp
        ? template["message"]
        : template["message"],

    "customerNo": call.customerNumber,
    "sessionId": call.sessionId,
    "callType": call.callDirection,
    "agentNo": call.agentNumber,
    "agentName": call.agentName,
    "dateTime": call.insertDateTime.toUtc().toIso8601String(),
    "callStatus": call.callStatus ?? 22,
    "duration": call.duration ?? 0,
    "type": "on_call",

    // campaign mapping from recent calls
    if (!isWhatsapp)
      "campaignName": call.queueName,
    if (isWhatsapp) ...{
      "campaign_name": call.queueName,
      "campaign_id": call.queueId?.toString(),
    },

    // only for SMS
    if (!isWhatsapp)
      "smsConfigId": template["sms_config_id"],
  };
}


}
