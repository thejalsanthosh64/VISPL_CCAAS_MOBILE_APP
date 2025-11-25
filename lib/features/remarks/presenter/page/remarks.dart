import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/common/widget/custom_field_deoration.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/features/remarks/cubit/remarks_cubit/remarks_cubit.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_required_fields_model.dart';
import 'package:kommuno/features/remarks/data/model/request/send_remarks_request_model.dart';
import 'package:kommuno/features/remarks/presenter/widget/remarks_list_tile.dart';
import 'package:kommuno/generated/assets.dart';

class RemarksScreen extends StatelessWidget {
  const RemarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    RemarksRequiredFieldsModel? remarksRequiredFieldsModel;
    if (args?["remarks_required_fields"] is RemarksRequiredFieldsModel) {
      remarksRequiredFieldsModel =
          args?["remarks_required_fields"] as RemarksRequiredFieldsModel;
    }

    if (remarksRequiredFieldsModel == null) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (context.mounted) {
            FToastManager()
                .showToast(message: AppLocalizations.of(context)!.dataNotFound);
            Navigator.of(context).pop();
          }
        },
      );
    }
    return BlocProvider(
      create: (__) => RemarksCubit(),
      child: _RemarksScreenState(
          remarksRequiredFieldsModel: remarksRequiredFieldsModel),
    );
  }
}

class _RemarksScreenState extends StatelessWidget {
  const _RemarksScreenState({
    this.remarksRequiredFieldsModel,
  });

  final RemarksRequiredFieldsModel? remarksRequiredFieldsModel;

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  RemarksCubit _remarksCubit(BuildContext context) =>
      context.read<RemarksCubit>();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.remarks,
          actions: [BreakInButton.outline()],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _kSized15,
            const AppAvatar(
              radius: 30,
              child: AppSvgPicture(
                assetName: Assets.iconsEdit,
                color: AppColors.white,
                width: 35,
              ),
            ),
            _kSized15,
            SizedBox(
              width: 200,
              height: 50,
              child: CustomFieldDecoration(
                value: addByIndiaCountryCodeWithoutPlus(
                    number: remarksRequiredFieldsModel?.customerNumber ?? ''),
                alignment: Alignment.center,
                suffixIcon: const [Icon(Icons.phone)],
              ),
            ),
            _kSized15,
            if ((remarksRequiredFieldsModel?.customerName ?? '')
                .trim()
                .isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  remarksRequiredFieldsModel?.customerName ?? '',
                  style: AppTextStyle.black23,
                ),
              ),
              _kSized10,
            ],
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocConsumer<RemarksCubit, RemarksState>(
      listener: (context, state) {
        if (state is RemarksSuccessState &&
            state.sendRemarksRequestModel != null) {
          Navigator.of(context).pop(state.sendRemarksRequestModel);
        }
      },
      builder: (context, state) {
        if (state is RemarksInitialState) {
          Future.delayed(
            Duration.zero,
            () {
              if (context.mounted) {
                _getRemarks(context);
              }
            },
          );
        } else if (state is RemarksLoadingState) {
          return const AppLoadingIndicator();
        } else if (state is RemarksErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              _getRemarks(context);
            },
          );
        } else if (state is RemarksSuccessState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.remarksDataModel.length,
                  itemBuilder: (__, index) {
                    return RemarksListTile(
                      remarks: state.remarksDataModel[index].remarks??"",
                      dateTime: state.remarksDataModel[index].startDateTime,
                    );
                  },
                ),
              ),
              _kSized15,
              _buildRemarksField(state: state, context: context),
              _kSized10,
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRemarksField(
      {required RemarksSuccessState state, required BuildContext context}) {
    return AppTextField(
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          if (!state.isSendButtonVisible) {
            _remarksCubit(context).changeSendIconVisibility(true);
          }
        } else {
          if (state.isSendButtonVisible) {
            _remarksCubit(context).changeSendIconVisibility(false);
          }
        }
      },
      maxLines: 3,
      minLines: 1,
      controller: _remarksCubit(context).remarksController,
      hintText: AppLocalizations.of(context)!.remarks,
      inputFormatters: [LengthLimitingTextInputFormatter(250)],
      maxLength: 250,
      suffixIcon: AnimatedSlide(
        offset:
            state.isSendButtonVisible ? const Offset(0, 0) : const Offset(2, 0),
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
            onTap: () {
              final smeId =
                  context.read<UserDetailsCubit>().userDetailsModel.smeId;
              _remarksCubit(context).setRemarks(
                  sendRemarksRequestModel: SendRemarksRequestModel(
                sessionId: remarksRequiredFieldsModel?.sessionId ?? '',
                remarks: _remarksCubit(context).remarksController.text.trim(),
                callDirection: remarksRequiredFieldsModel?.callDirection ?? '',
                smeId: smeId,
                customerNumber:
                    remarksRequiredFieldsModel?.customerNumber ?? '',
                insertDateTime: DateTime.now(),
              ),smeId: smeId);
            },
            customBorder: const CircleBorder(),
            child: const AppAvatar(
              radius: 20,
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getRemarks(BuildContext context) {
    if (remarksRequiredFieldsModel?.customerNumber != null) {
      final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
      _remarksCubit(context).getRemarksList(
          remarksRequestModel: RemarksRequestModel(
        customerNumber: remarksRequiredFieldsModel!.customerNumber,
        smeId: smeId,
      ),smeId: smeId);
    }
  }
}
