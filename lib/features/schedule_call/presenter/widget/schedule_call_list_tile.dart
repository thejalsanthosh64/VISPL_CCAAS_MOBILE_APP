import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outlined_avatar.dart';
import 'package:kommuno/core/common/widget/app_slidable_action.dart';
import 'package:kommuno/core/common/widget/make_call_button.dart';
import 'package:kommuno/core/common/widget/whatsapp_launcher_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/schedule_call/data/model/response/schedule_calls_response_model.dart';
import 'package:kommuno/generated/assets.dart';

class ScheduleCallListTile extends StatelessWidget {
  const ScheduleCallListTile({
    super.key,
    required this.index,
    required this.scheduleCallDetail,
  });

  final int index;

  final ScheduleDetails scheduleCallDetail;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey<String>(
          "ScheduleCallList_ScheduleCallListTile_Slidable_${index}_${scheduleCallDetail.id}"),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context)
                  .pushNamed(AppRouteNames.addScheduleCall, arguments: {
                "number": scheduleCallDetail.customerNumber,
                "customerName": scheduleCallDetail.customerName
              });
            },
            backgroundColor: AppColors.green,
            text: "Done",
            iconName: Assets.iconsCheck,
          ),
        ],
      ),
      child: ColoredBox(
        color: index.isEven ? AppColors.white : AppColors.whiteGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: AppConstant.kBodyHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppOutlinedAvatar(
                          child: (scheduleCallDetail.customerName ?? '')
                                  .trim()
                                  .isEmpty
                              ? const Icon(Icons.person)
                              : Padding(
                                  padding: EdgeInsets.only(
                                      bottom: AppConstant.kCenterPadding),
                                  child: Text(
                                    (scheduleCallDetail.customerName ?? '')
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
                                  scheduleCallDetail.customerName ??
                                      addByIndiaCountryCodeWithoutPlus(
                                          number: scheduleCallDetail
                                              .customerNumber),
                                  style: AppTextStyle.black16,
                                ),
                              ),
                              if ((scheduleCallDetail.customerName ?? '')
                                  .isNotEmpty)
                                FittedBox(
                                  child: Text(
                                    addByIndiaCountryCodeWithoutPlus(
                                        number:
                                            scheduleCallDetail.customerNumber),
                                    style: AppTextStyle.black16,
                                  ),
                                ),
                              if (scheduleCallDetail.insertDateTime != null)
                                FittedBox(
                                  child: Text(
                                    DateUtility.getDisplayDateTimeWithMonthName(
                                        date:
                                            scheduleCallDetail.insertDateTime!),
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
                      number: scheduleCallDetail.customerNumber),
                  _kSized5,
                  MakeCallButton(
                    number: scheduleCallDetail.customerNumber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
