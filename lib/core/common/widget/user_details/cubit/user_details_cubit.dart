import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/common/widget/user_details/data/repository/user_details_repo.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(const UserDetailsInitialState());

  final _userDetailsRepo = UserDetailsRepo();

  late UserDetailsModel userDetailsModel;

  Future<void> loadUserDetails({bool isLoading = true}) async {
    try {
      if (isLoading) {
        emit(const UserDetailsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
      }
      final res = await _userDetailsRepo.loadUserDetails();
      if (res.isSuccess) {
        final data = List<Map<String, dynamic>>.from(res.data as List);
        if (data. isNotEmpty) {
          userDetailsModel = UserDetailsModel.fromJson(data.first);
          emit(UserDetailsSuccessState(userDetailsModel: userDetailsModel));
        } else {
          emit(const UserDetailsNotFoundState());
        }
      } else {
        if (isLoading) {
          emit(const UserDetailsErrorState());
        }

        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const UserDetailsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const UserDetailsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("UserDetailsCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }
}
