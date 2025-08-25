import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';
import 'package:kommuno/core/common/widget/bottom_sheet_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/leads/cubit/add_lead_note_cubit/add_lead_note_cubit.dart';
import 'package:kommuno/features/leads/presenter/widget/lead_text_field.dart';

class AddLeadNote extends StatelessWidget {
  const AddLeadNote(
      {super.key, this.customerName, required this.customerNumber});

  final String? customerName;
  final String customerNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddLeadNoteCubit(),
      child: _AddLeadNoteState(
        customerNumber: customerNumber,
        customerName: customerName,
      ),
    );
  }
}

class _AddLeadNoteState extends StatelessWidget {
  const _AddLeadNoteState({this.customerName, required this.customerNumber});

  final String? customerName;
  final String customerNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: _buildBody(),
    );
  }

  AddLeadNoteCubit _addLeadNoteCubit(BuildContext context) =>
      context.read<AddLeadNoteCubit>();

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: BlocConsumer<AddLeadNoteCubit, AddLeadNoteState>(
        listener: (context, state) {
          if (state.addCustomerNoteRequest != null) {
            Navigator.of(context).pop(state.addCustomerNoteRequest);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomSheetHeader(
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        customerName ??
                            addByIndiaCountryCodeWithoutPlus(
                                number: customerNumber),
                        style: BottomSheetHeader.titleStyle),
                    if ((customerName ?? '').isNotEmpty)
                      Text(
                          addByIndiaCountryCodeWithoutPlus(
                              number: customerNumber),
                          style: AppTextStyle.white16),
                  ],
                ),
              ),
              _kSized10,
              LeadTextField(
                textInputAction: TextInputAction.done,
                title: AppLocalizations.of(context)!.note,
                hintText: AppLocalizations.of(context)!.typeYourNote,
                controller: _addLeadNoteCubit(context).noteController,
                maxLines: 3,
                autofocus: true,
              ),
              _kSized10,
              const Spacer(),
              AppOutlineButton(
                text: AppLocalizations.of(context)!.addNote,
                onTap: () {
                  final smeId =
                      context.read<UserDetailsCubit>().userDetailsModel.smeId;
                  _addLeadNoteCubit(context).addLeadNoteCubit(
                    noteText: _addLeadNoteCubit(context).noteController.text,
                    customerNumber: customerNumber,
                    smeId: smeId,
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
