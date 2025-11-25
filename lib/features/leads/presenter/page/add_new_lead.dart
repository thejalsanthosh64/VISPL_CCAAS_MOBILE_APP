import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';
import 'package:kommuno/core/common/widget/bottom_sheet_header.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/features/leads/cubit/add_lead_cubit/add_lead_cubit.dart';
import 'package:kommuno/features/leads/presenter/widget/lead_text_field.dart';
import 'package:kommuno/features/leads/presenter/widget/leads_dropdown.dart';

class AddNewLead extends StatelessWidget {
  const AddNewLead({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (__) => AddLeadCubit(),
      child: const _AddNewLeadState(),
    );
  }
}

class _AddNewLeadState extends StatelessWidget {
  const _AddNewLeadState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: _buildBody(),
    );
  }

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  AddLeadCubit _addLeadCubit(BuildContext context) =>
      context.read<AddLeadCubit>();

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child:
          BlocConsumer<AddLeadCubit, AddLeadState>(listener: (context, state) {
        if (state.addLeadRequestModel != null) {
          Navigator.of(context).pop(state.addLeadRequestModel);
        }
      }, builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetHeader(title: AppLocalizations.of(context)!.addLead),
            _kSized10,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LeadTextField(
                      title: AppLocalizations.of(context)!.mobileNumber,
                      controller: _addLeadCubit(context).phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    _kSized10,
                    LeadsDropdown<String>(
                      title: AppLocalizations.of(context)!.styckyType,
                      onChanged: (value) {
                        _addLeadCubit(context).selectStickyType(value!);
                      },
                      value: state.selectedStickyType,
                      onBuildText: (value) {
                        return value;
                      },
                      onBuildValue: (value) {
                        return value;
                      },
                      items: [
                        AppLocalizations.of(context)!.soft,
                        AppLocalizations.of(context)!.hard
                      ],
                    )
                  ],
                ),
              ),
            ),
            _kSized10,
            AppOutlineButton(
              text: AppLocalizations.of(context)!.save,
              onTap: () {
                _addLeadCubit(context).addManualLead(
                    customerNumber: _addLeadCubit(context).phoneController.text,
                    smeId:
                        context.read<UserDetailsCubit>().userDetailsModel.smeId,
                    stickyType: state.selectedStickyType);
              },
            )
          ],
        );
      }),
    );
  }
}
