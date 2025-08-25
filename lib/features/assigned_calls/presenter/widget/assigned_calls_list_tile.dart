import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outlined_avatar.dart';
import 'package:kommuno/core/common/widget/app_slidable_action.dart';
import 'package:kommuno/core/common/widget/make_call_button.dart';
import 'package:kommuno/core/common/widget/slidable_icon_button.dart';
import 'package:kommuno/core/common/widget/whatsapp_launcher_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/assigned_calls/data/model/assigned_calls_list_model.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_required_fields_model.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignedCallsListTile extends StatelessWidget {
  const AssignedCallsListTile({
    super.key,
    required this.assignedCallsDetails,
    required this.index,
    required this.slidableController,
  });

  final AssignedCallsDetails assignedCallsDetails;

  final int index;

  final SlidableController slidableController;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    final isCustomerNameEmpty =
        (assignedCallsDetails.customerName ?? '').trim().isEmpty;
    return Slidable(
      controller: slidableController,
      key: ValueKey<String>(
          "AssignedCallsList_AssignedCallsListTile_Slidable_$index${assignedCallsDetails.id}"),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.35,
        children: [
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context)
                  .pushNamed(AppRouteNames.remarks, arguments: {
                "remarks_required_fields": RemarksRequiredFieldsModel(
                  customerNumber: assignedCallsDetails.customerNumber,
                  sessionId: assignedCallsDetails.sessionId,
                  callDirection:
                      RemarksRequiredFieldsModel.defaultCallDirection,
                  customerName: assignedCallsDetails.customerName,
                )
              });
            },
            backgroundColor: AppColors.green,
            text: AppLocalizations.of(context)!.remarks,
            iconName: Assets.iconsEdit,
          ),
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context)
                  .pushNamed(AppRouteNames.addScheduleCall, arguments: {
                "number": assignedCallsDetails.customerNumber,
                "customerName": assignedCallsDetails.customerName
              });
            },
            backgroundColor: AppColors.appColor,
            text: AppLocalizations.of(context)!.schedule,
            iconName: Assets.iconsSchedule,
          ),
        ],
      ),
      child: ColoredBox(
        color: index.isOdd ? AppColors.white : AppColors.whiteGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: AppConstant.kBodyHorizontalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppOutlinedAvatar(
                      child: isCustomerNameEmpty
                          ? const Icon(Icons.person)
                          : Padding(
                              padding: EdgeInsets.only(
                                  bottom: AppConstant.kCenterPadding),
                              child: Text(
                                (assignedCallsDetails.customerName ?? '')
                                    .capitalizeFirstLetterOfTwoWords,
                                style: AppTextStyle.appColor16,
                              ),
                            ),
                    ),
                    _kSized10,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            child: Text(
                              isCustomerNameEmpty
                                  ? addByIndiaCountryCodeWithoutPlus(
                                      number:
                                          assignedCallsDetails.customerNumber)
                                  : assignedCallsDetails.customerName ??
                                      addByIndiaCountryCodeWithoutPlus(
                                          number: assignedCallsDetails
                                              .customerNumber),
                              style: AppTextStyle.black16,
                              maxLines: 1,
                            ),
                          ),
                          if (!isCustomerNameEmpty)
                            FittedBox(
                              child: Text(
                                addByIndiaCountryCodeWithoutPlus(
                                    number:
                                        assignedCallsDetails.customerNumber),
                                style: AppTextStyle.blackNormal,
                                maxLines: 1,
                              ),
                            ),
                          FittedBox(
                            child: Text(
                              DateUtility.getDisplayDateTimeWithMonthName(
                                  date: assignedCallsDetails.endDateTime),
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
              WhatsappLauncherButton(
                number: assignedCallsDetails.customerNumber,
              ),
              _kSized5,
              MakeCallButton(
                number: assignedCallsDetails.customerNumber,
              ),
              SlidableIconButton(slidableController: slidableController),
            ],
          ),
        ),
      ),
    );
  }
}
