import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/call_manager/call_manager.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/dial/data/model/dial_data_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'dial_state.dart';

class DialCubit extends Cubit<DialState> {
  DialCubit() : super(const DialState());

  final dialController = TextEditingController();

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
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.invalidMobile);
    }
  }
}
