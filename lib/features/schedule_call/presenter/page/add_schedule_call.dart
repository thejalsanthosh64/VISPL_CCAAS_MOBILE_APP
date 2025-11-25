import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_button.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/common/widget/custom_field_deoration.dart';
import 'package:kommuno/core/common/widget/mobile_textfield.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/schedule_call/cubit/add_schedule_call_cubit/add_schedule_call_cubit.dart';

class AddScheduleCall extends StatelessWidget {
  const AddScheduleCall({super.key});

  @override
  Widget build(BuildContext context) {
    String? number;
    String customerName = "";
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args?["number"] is String) {
      number = args!["number"]!;
    }

    if (args?["customerName"] is String) {
      customerName = args!["customerName"];
    }

    return BlocProvider(
      create: (context) => AddScheduleCallCubit(),
      child: _AddScheduleCallState(
        number: number ?? '',
        customerName: customerName,
      ),
    );
  }
}

class _AddScheduleCallState extends StatelessWidget {
  const _AddScheduleCallState(
      {required this.number, required this.customerName});

  final String number;
  final String customerName;

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  AddScheduleCallCubit _addScheduleCallCubit(BuildContext context) =>
      context.read<AddScheduleCallCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.scheduleACall,
        actions: [BreakInButton.outline()],
      ),
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
        final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.kBodyHorizontalPadding),
        child: BlocConsumer<AddScheduleCallCubit, AddScheduleCallState>(
          listener: (context, state) {
            if (state is AddSScheduleCallSuccessState) {
              if (state.addScheduleCallRequestModel != null) {
                Navigator.of(context).pop(state.addScheduleCallRequestModel);
              }
            }
          },
          builder: (context, state) {
            if (state is AddSScheduleCallInitialState) {
              Future.delayed(
                Duration.zero,
                () {
                  if (context.mounted) {
                    _addScheduleCallCubit(context).setData(number: number);
                  }
                },
              );
            } else if (state is AddSScheduleCallSuccessState) {
              return Column(
                children: [
                  _kSized20,
                  MobileTextField(
                    readOnly: number.isNotEmpty,
                    controller: _addScheduleCallCubit(context).mobileController,
                    textInputAction: TextInputAction.next,
                  ),
                  _kSized20,
                  AppTextField(
                    autofocus: false,
                    controller: _addScheduleCallCubit(context).noteController,
                    focusNode: _addScheduleCallCubit(context).noteFocusNode,
                    prefixIcon: const Icon(
                      Icons.apartment_sharp,
                      color: AppColors.appColor,
                    ),
                    hintText: AppLocalizations.of(context)!.note,
                  ),
                  _kSized20,
                  CustomFieldDecoration(
                    hinText: AppLocalizations.of(context)!.selectDateTime,
                    value: state.selectedDateTime != null
                        ? DateUtility.getDisplayDateTimeWithoutMonthName(
                            date: state.selectedDateTime!)
                        : null,
                    onTap: () {
                      _addScheduleCallCubit(context).noteFocusNode.nextFocus();
                      _addScheduleCallCubit(context)
                          .selectDateTime(context: context);
                    },
                    suffixIcon: const [Icon(Icons.calendar_month)],
                  ),
                  _kSized20,
                  AppButton(
                    text: AppLocalizations.of(context)!.save,
                    onTap: () {
                      _addScheduleCallCubit(context).addScheduleCall(
                         smeId: smeId,
                        number: _addScheduleCallCubit(context)
                            .mobileController
                            .text,
                        note:
                            _addScheduleCallCubit(context).noteController.text,
                        selectedDateTime: state.selectedDateTime,
                        customerName: customerName,
                      );
                    },
                  ),
                  _kSized20
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
