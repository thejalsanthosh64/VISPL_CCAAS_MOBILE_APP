import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/leads/data/model/request/add_customer_note_request.dart';
import 'package:kommuno/features/leads/data/repository/lead_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'add_lead_note_state.dart';

class AddLeadNoteCubit extends Cubit<AddLeadNoteState> {
  AddLeadNoteCubit() : super(const AddLeadNoteState());

  final noteController = TextEditingController();

  final _leadRepo = LeadRepo();

  @override
  Future<void> close() async {
    noteController.dispose();
    super.close();
  }

  Future<void> addLeadNoteCubit({
    required String noteText,
    required String customerNumber,
    required int smeId,
  }) async {
    try {
      if (AppValidation.isEmpty(noteText)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterNote);
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        final addCustomerNoteRequest = AddCustomerNoteRequest(
          remarks: noteText,
          insertDateTime: DateTime.now(),
          customerNumber: customerNumber,
        );
        final res = await _leadRepo.addCustomerNote(
          addCustomerNoteRequest: addCustomerNoteRequest,
          smeId: smeId,
        );
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {
          emit(
              AddLeadNoteState(addCustomerNoteRequest: addCustomerNoteRequest));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AddCustomerNoteCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
