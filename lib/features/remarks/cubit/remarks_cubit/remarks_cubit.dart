import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/request/send_remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/response/remarks_data_model.dart';
import 'package:kommuno/features/remarks/data/repository/remarks_repo.dart';

part 'remarks_state.dart';

// class RemarksCubit extends Cubit<RemarksState> {
//   RemarksCubit() : super(const RemarksInitialState());

//   final _remarksRepo = RemarksRepo();

//   final remarksController = TextEditingController();

//   @override
//   Future<void> close() async {
//     remarksController.dispose();
//     super.close();
//   }

//   Future<void> getRemarksList(
//       {required RemarksRequestModel remarksRequestModel,required int smeId}) async {
//     try {
//       emit(const RemarksLoadingState());
//       final res = await _remarksRepo.getRemarksList(
//           remarksRequestModel: remarksRequestModel,smeId: smeId);
//       if (res.isSuccess) {
//         final remarksDataModel = List<RemarksDataModel>.from(
//           (res.data as List<dynamic>).map(
//             (e) => RemarksDataModel.fromJson(e),
//           ),
//         );
//         if (state is RemarksSuccessState) {
//           emit((state as RemarksSuccessState)
//               .copyWith(remarksDataModel: remarksDataModel));
//         } else {
//           emit(RemarksSuccessState(remarksDataModel: remarksDataModel));
//         }
//       } else {
//         emit(const RemarksErrorState());
//         FToastManager().showToast(message: res.message);
//       }
//     } on AppDioException catch (e) {
//       emit(const RemarksErrorState());
//       FToastManager().showToast(message: e.message);
//     } catch (e, s) {
//       emit(const RemarksErrorState());
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("RemarksCubit $e");
//       debugPrint("$s");
//     }
//   }

//   void changeSendIconVisibility(bool visible) {
//     if (state is RemarksSuccessState) {
//       emit((state as RemarksSuccessState)
//           .copyWith(isSendButtonVisible: visible));
//     }
//   }

//   Future<void> setRemarks(
//       {required SendRemarksRequestModel sendRemarksRequestModel,required int smeId}) async {
//     try {
//       AppLoadingIndicator.showLoadingIndicator();
//       final res = await _remarksRepo.setRemarks(
//           sendRemarksRequestModel: sendRemarksRequestModel,smeId: smeId);
//       if (res.isSuccess) {
//         if (state is RemarksSuccessState) {
//           emit((state as RemarksSuccessState)
//               .copyWith(sendRemarksRequestModel: sendRemarksRequestModel));
//         }
//       } else {
//         FToastManager().showToast(message: res.message);
//       }
//     } on AppDioException catch (e) {
//       FToastManager().showToast(message: e.message);
//     } catch (e, s) {
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("RemarksCubit $e");
//       debugPrint("$s");
//     }
//     AppLoadingIndicator.dismissLoadingIndicator();
//   }
// }



class RemarksCubit extends Cubit<RemarksState> {
  RemarksCubit() : super(const RemarksInitialState());

  final _remarksRepo = RemarksRepo(); // Ensure this repo matches the new API calls
  final remarksController = TextEditingController();

  @override
  Future<void> close() async {
    remarksController.dispose();
    super.close();
  }

  // Sorting Helper
  List<RemarksDataModel> _sortRemarks(List<RemarksDataModel> list) {
    list.sort((a, b) {
      final dateA = a.updatedAt ?? a.createdAt;
      final dateB = b.updatedAt ?? b.createdAt;
      return dateB.compareTo(dateA); // Descending: latest on top
    });
    return list;
  }

  Future<void> getRemarksList({required Map<String, dynamic> payload, required int smeId}) async {
    try {
      emit(const RemarksLoadingState());
      // UPDATE THIS REPO CALL to match your new getListRemarks API
      final res = await _remarksRepo.getListRemarks(payload: payload, smeId: smeId);
      
      if (res.isSuccess) {
        var remarksDataModel = List<RemarksDataModel>.from(
          (res.data as List<dynamic>).map((e) => RemarksDataModel.fromJson(e)),
        );
        
        remarksDataModel = _sortRemarks(remarksDataModel);

        emit(RemarksSuccessState(remarksDataModel: remarksDataModel));
      } else {
        emit(const RemarksErrorState());
        FToastManager().showToast(message: res.message);
      }
    } catch (e) {
      emit(const RemarksErrorState());
      FToastManager().showToast(message: "Failed to load remarks");
    }
  }

  
// Handles both Adding and Updating
  Future<void> addOrUpdateRemark({
    required Map<String, dynamic> payload,
    required int smeId,
    required bool isUpdating,
  }) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      
      final res = isUpdating 
          ? await _remarksRepo.updateRemark(payload: payload, smeId: smeId)
          : await _remarksRepo.setRemarks(payload: payload, smeId: smeId);

      if (res.isSuccess) {
        var updatedList = List<RemarksDataModel>.from(
          (res.data as List<dynamic>).map((e) => RemarksDataModel.fromJson(e)),
        );

        updatedList = _sortRemarks(updatedList);
        
        remarksController.clear();

        if (state is RemarksSuccessState) {
          emit((state as RemarksSuccessState).copyWith(
            remarksDataModel: updatedList,
            clearEditing: true, // ✅ FIX: Use this instead of editingRemarkId: null
            isSendButtonVisible: false,
          ));
        }
      } else {
        FToastManager().showToast(message: res.message);
      }
    } catch (e) {
      FToastManager().showToast(message: "Failed to save remark");
    } finally {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }


  void startEditing(RemarksDataModel remark) {
    if (state is RemarksSuccessState) {
      remarksController.text = remark.message;
      emit((state as RemarksSuccessState).copyWith(
        editingRemarkId: remark.id,
        isSendButtonVisible: true,
      ));
    }
  }

  void cancelEditing() {
    if (state is RemarksSuccessState) {
      remarksController.clear();
      // We pass a unique string "CLEAR" to force the copyWith to null out the ID
      // since Dart copyWith patterns usually struggle with setting things explicitly to null.
      emit((state as RemarksSuccessState).copyWith(
        clearEditing: true, 
        isSendButtonVisible: false,
      ));
    }
  }

  void changeSendIconVisibility(bool visible) {
    if (state is RemarksSuccessState) {
      emit((state as RemarksSuccessState).copyWith(isSendButtonVisible: visible));
    }
  }
}

