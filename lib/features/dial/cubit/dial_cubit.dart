import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/call_manager/call_manager.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/dial/data/model/dial_data_model.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/dial/data/repository/dial_repo.dart';

part 'dial_state.dart';

class DialCubit extends Cubit<DialState> {
  DialCubit() : super(const DialState());

  final dialController = TextEditingController();
  final _dialRepo = DialRepo();

  @override
  Future<void> close() async {
    dialController.dispose();
    super.close();
  }

  void changeDialNo(DialDataModel dialData) {
    String dialNo = state.number;
    if (dialNo.length < 10) {
      final cursorPosition = dialController.selection.base.offset;
      final latest = dialNo.split("");
      latest.insert(cursorPosition, dialData.dialNo);
      dialNo = latest.join();
      dialController.text = dialNo;
      emit(state.copyWith(number: dialNo));
      dialController.selection = TextSelection(
        baseOffset: cursorPosition + 1,
        extentOffset: cursorPosition + 1,
      );
    }
  }

  void deleteDialNo() {
    String dialNo = state.number;
    final baseOffset = dialController.selection.base.offset;
    final extentOffset = dialController.selection.extent.offset;
    if (dialNo.isNotEmpty) {
      if (baseOffset == extentOffset) {
        if (baseOffset > 0) {
          final latest = dialNo.split("");
          latest.removeAt(baseOffset - 1);
          dialNo = latest.join();
          dialController.text = dialNo;
          emit(state.copyWith(number: dialNo));
          dialController.selection = TextSelection(
            baseOffset: baseOffset - 1,
            extentOffset: baseOffset - 1,
          );
        }
      } else {
        final latest = dialNo.split("");
        latest.removeRange(baseOffset, extentOffset);
        dialNo = latest.join();
        dialController.text = dialNo;
        emit(state.copyWith(number: dialNo));
        dialController.selection = TextSelection(
          baseOffset: baseOffset,
          extentOffset: baseOffset,
        );
      }
    }
  }

  void clearDialField() {
    String dialNo = state.number;
    if (dialNo.isNotEmpty) {
      dialNo = '';
      dialController.text = dialNo;
      emit(state.copyWith(number: dialNo));
    }
  }

  void makeNewCall() {
    if (AppValidation.isValidNumber(state.number)) {
      CallManager.makeNewCall(number: state.number);
    } else {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnteraValidNumber);
    }
  }

Future<void> toggleDialer({
    required int agentId,
    required bool value,
    required int smeID,
    required BuildContext context
  }) async {
    try {
      emit(state.copyWith(isUpdating: true));

      final res = await _dialRepo.setDialerStatus(
        agentId: agentId,
        isOn: value,
        smeId: smeID
      );

      if (res.isSuccess) {
        emit(state.copyWith(
          isDialerOn: value,
          isUpdating: false,
        ));

         final userCubit = context.read<UserDetailsCubit>();
      final user = userCubit.userDetailsModel;

      userCubit.userDetailsModel = user.copyWith(
        autoDialerCallsStatus: value ? 1 : 0,
      );
      }

      FToastManager().showToast(message: res.message);
    } catch (e) {
      emit(state.copyWith(isUpdating: false));
      FToastManager().showToast(message: "Failed to update dialer status");
    }
  }

void syncFromUserDetails(UserDetailsModel user) {
  emit(
    state.copyWith(
      isDialerOn: user.autoDialerCallsStatus == 1,
    ),
  );
}

}
