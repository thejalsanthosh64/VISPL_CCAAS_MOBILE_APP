import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_outlined_avatar.dart';
import 'package:kommuno/core/common/widget/make_call_button.dart';
import 'package:kommuno/core/common/widget/whatsapp_launcher_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/follow_up/data/model/follow_up_list_model.dart';
class FollowUpListTile extends StatelessWidget {
  const FollowUpListTile({
    super.key,
    required this.followUpDetail,
    required this.index,
    this.onPressPendingButton,
    this.onPressDelete,
    this.showDeleteDialog,   
  });

  final FollowUpDetails followUpDetail;

  final void Function(FollowUpDetails followUpDetail)? onPressPendingButton;
  final void Function(FollowUpDetails followUpDetail)? onPressDelete;

  final Future<bool?> Function(BuildContext context)? showDeleteDialog;

  final int index;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    final isCustomerNameEmpty = followUpDetail.customerName.trim().isEmpty;

    return ColoredBox(
      color: index.isOdd ? AppColors.white : AppColors.whiteGrey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: AppConstant.kBodyHorizontalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  AppOutlinedAvatar(
                    child: isCustomerNameEmpty
                        ? const Icon(Icons.person)
                        : Padding(
                            padding: EdgeInsets.only(
                                bottom: AppConstant.kCenterPadding),
                            child: Text(
                              followUpDetail.customerName
                                  .capitalizeFirstLetterOfTwoWords,
                              style: AppTextStyle.appColor16,
                            ),
                          ),
                  ),
                  _kSized10,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            isCustomerNameEmpty
                                ? addByIndiaCountryCodeWithoutPlus(
                                    number: followUpDetail.customerNumber)
                                : followUpDetail.customerName,
                            style: AppTextStyle.black16,
                            maxLines: 1,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            DateUtility.getDisplayDateTimeWithMonthName(
                                date: followUpDetail.reminderDateTime),
                            style: AppTextStyle.grey13,
                          ),
                        ),
                        Text(
                          followUpDetail.message,
                          style: AppTextStyle.appColorNormal,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _kSized5,
            InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressPendingButton != null &&
                      followUpDetail.isPending
                  ? () => onPressPendingButton?.call(followUpDetail)
                  : null,
              child: AppAvatar(
                child: Icon(
                  followUpDetail.isPending
                      ? Icons.restore
                      : Icons.done_rounded,
                  color: AppColors.white,
                ),
              ),
            ),

            _kSized5,
            WhatsappLauncherButton(
                number: followUpDetail.customerNumber),

            _kSized5,
            IgnorePointer(
              ignoring: !followUpDetail.isPending,
              child: MakeCallButton(
                number: followUpDetail.customerNumber,
                backgroundColor:
                    followUpDetail.isPending ? null : AppColors.grey,
              ),
            ),

            _kSized10,
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                if (showDeleteDialog == null) return;

                final shouldDelete =
                    await showDeleteDialog!.call(context);

                if (shouldDelete == true) {
                  onPressDelete?.call(followUpDetail);
                }
              },
              child: const AppAvatar(
                child: Icon(
                  Icons.delete,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
