import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_button.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';
import 'package:kommuno/features/break/data/model/break_in_request_model.dart';
import 'package:kommuno/features/break/data/model/break_out_request_model.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class BreakInButton extends StatelessWidget {
  const BreakInButton._private(this._isOutline);

  final bool _isOutline;

  factory BreakInButton.outline() {
    return const BreakInButton._private(true);
  }

  static const _kBreakInButtonSize = Size(90, 30);

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  factory BreakInButton.filled() {
    return const BreakInButton._private(false);
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<BreakCubit, BreakState>(
      builder: (context, state) {
        bool isOnBreak = false;
        var statusData = _getStatusData(context: context, isOnBreak: false);
        if (state is BreakSuccessState) {
          isOnBreak = state.isOnBreak;
          statusData = _getStatusData(context: context, isOnBreak: isOnBreak);
        }

        if (_isOutline && !isOnBreak) {
          
          return AppOutlineButton(
            width: _kBreakInButtonSize.width,
            height: _kBreakInButtonSize.height,
            text: statusData.$1,
            borderColor: statusData.$2,
            textStyle: statusData.$3,
            onTap: () {
              _onTap(context: context, isOnBreak: isOnBreak);
            },
          );
        } else {
          return AppButton(
            width: _kBreakInButtonSize.width,
            height: _kBreakInButtonSize.height,
            text: statusData.$1,
            color: statusData.$2,
            textStyle: statusData.$3,
            onTap: () {
              _onTap(context: context, isOnBreak: isOnBreak);
            },
          );
        }
      },
    );
  }

  BreakCubit _breakCubit(BuildContext context) => context.read<BreakCubit>();

  void _onTap({required BuildContext context, required bool isOnBreak}) {
    final userDetails = context.read<UserDetailsCubit>().userDetailsModel;
    if (userDetails.breakPermissionFlag == 0) {
      FToastManager().showToast(
          message: AppLocalizations.of(context)!.breaksAreNotAllowed);
          
    } else if (userDetails.status == 0) {
      FToastManager().showToast(
          message: AppLocalizations.of(context)!.youAreCurrentlyInactive);
    } else if (isOnBreak) {
            final now = DateTime.now();

    _breakCubit(context).breakOut(
      context: context,
  breakOutRequestData: BreakOutRequestModel(
    smeId: "${userDetails.smeId}",
    endDate: now,
    endDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
  ),
);

    } else {
      _breakInRequest(context: context, userDetails: userDetails);
    }
  }

  void _breakInRequest(
      {required BuildContext context,
      required UserDetailsModel userDetails}) async {
    final selectedReason = ValueNotifier<String>('');
    final requestBreakIn = await appDialog<bool>(
      context: context,
      constraints: const BoxConstraints(maxHeight: 220),
      customBody: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.addBreakReason,
              style: AppTextStyle.appColor18,
            ),
            const SizedBox(height: AppConstant.kSized10),
            Flexible(
              child: ValueListenableBuilder<String>(
                valueListenable: selectedReason,
                builder: (__, selected, child) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 50,
                    ),
                    itemCount: _breakCubit(context).breakReasonList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (__, index) {
                      return RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: const Offset(-20, 0),
                          child: Text(
                            _breakCubit(context).breakReasonList[index],
                            style: AppTextStyle.blackNormal,
                          ),
                        ),
                        value: _breakCubit(context).breakReasonList[index],
                        fillColor: const WidgetStatePropertyAll<Color>(
                            AppColors.appColor),
                        groupValue: selected,
                        onChanged: (String? value) {
                          selectedReason.value = value ?? '';
                        },
                      );
                    },
                  );
                },
              ),
            ),
            _kSized15,
            const Divider(height: 0, thickness: 2, color: AppColors.appColor)
          ],
        ),
      ),
      actions: (ctx) {
        return [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text(
              AppLocalizations.of(ctx)!.cancel,
              style: AppTextStyle.appColor18,
            ),
          ),
          TextButton(
            onPressed: () {
              if (AppValidation.isEmpty(selectedReason.value)) {
                FToastManager().showToast(
                    message: AppLocalizations.of(context)!.pleaseSpecifyReason);
              } else {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text(
              AppLocalizations.of(ctx)!.save,
              style: AppTextStyle.appColor18,
            ),
          ),
          const SizedBox(width: 5),
        ];
      },
    );
    if (context.mounted) {
      selectedReason.dispose();
      if (requestBreakIn ?? false) {
      final now = DateTime.now();

_breakCubit(context).breakIn(
  context: context,
  breakInRequestData: BreakInRequestModel(
    message: selectedReason.value,
    smeId: "${userDetails.smeId}",
    startDate: now,  
    startDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
  ),


);

      }
    }
  }

  (String value, Color color, TextStyle style) _getStatusData(
      {required bool isOnBreak, required BuildContext context}) {
    if (_isOutline) {
      if (isOnBreak) {
        return (
          AppLocalizations.of(context)!.breakOut,
          AppColors.orange,
          AppTextStyle.whiteNormal
        );
      } else {
        return (
          AppLocalizations.of(context)!.breakIn,
          AppColors.white,
          AppTextStyle.whiteNormal
        );
      }
    } else {
      if (isOnBreak) {
        return (
          AppLocalizations.of(context)!.breakOut,
          AppColors.orange,
          AppTextStyle.whiteNormal
        );
      } else {
        return (
          AppLocalizations.of(context)!.breakIn,
          AppColors.appColor,
          AppTextStyle.whiteNormal
        );
      }
    }
  }
}
