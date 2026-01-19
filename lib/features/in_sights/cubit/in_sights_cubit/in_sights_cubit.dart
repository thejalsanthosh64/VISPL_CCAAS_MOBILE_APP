import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/in_sights/data/enum/in_sights_date_enum.dart';
import 'package:kommuno/features/in_sights/data/model/response/disposition_summary_response.dart';
import 'package:kommuno/features/in_sights/data/model/response/in_sights_response.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/in_sights/data/repository/in_sights_repo.dart';

part 'in_sights_state.dart';

// class InSightsCubit extends Cubit<InSightsState> {
//   InSightsCubit() : super(const InSightsInitialState());

//   final _inSightsRepo = InSightsRepo();

//   Future<void> getInSights({
//     bool isLoading = false,
//     required int smeId,
//     DateTimeRange? selectedDateTimeRange,
//     InSightsDateEnum? inSightsDateEnum,
//   }) async {
//     try {
//       if (isLoading) {
//         emit(const InSightsLoadingState());
//       } else {
//         AppLoadingIndicator.showLoadingIndicator();
//       }

//       final dateTimeRange = selectedDateTimeRange ??
//           _getDateTimeRange(inSightsDateEnum ?? InSightsDateEnum.today);

//       final res = await _inSightsRepo.getInsight(
//         startDate: dateTimeRange.start,
//         endDate: dateTimeRange.end,
//         smeId: smeId,
//       );

//       final dispositionRes = await _inSightsRepo.getDispositionSummary(
//   smeId: smeId,
//   startDate: dateTimeRange.start,
//   endDate: dateTimeRange.end,
// );

//       if (res.isSuccess) {
//         if (state is InSightsSuccessState) {
//           emit((state as InSightsSuccessState).copyWith(
//             inSightsDateEnum: () => inSightsDateEnum,
//             dateTimeRange: () => selectedDateTimeRange,
//             insightsResponse: InsightsResponse.fromJson(res.data[0]),
//           ));
//         } else {
//           emit(
//             InSightsSuccessState(
//               insightsResponse: InsightsResponse.fromJson(res.data[0]),
//               dateTimeRange: selectedDateTimeRange,
//               inSightsDateEnum: inSightsDateEnum,
//             ),
//           );
//         }
//       } else {
//         if (isLoading) {
//           emit(const InSightsErrorState());
//         }
//         FToastManager().showToast(message: res.message);
//       }
//     } on AppDioException catch (e) {
//       if (isLoading) {
//         emit(const InSightsErrorState());
//       }
//       FToastManager().showToast(message: e.message);
//     } catch (e, s) {
//       if (isLoading) {
//         emit(const InSightsErrorState());
//       }
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("InSightsCubit $e");
//       debugPrint("$s");
//     }

//     if (!isLoading) {
//       AppLoadingIndicator.dismissLoadingIndicator();
//     }
//   }

//   DateTimeRange _getDateTimeRange(InSightsDateEnum inSightsDateEnum) {
//     switch (inSightsDateEnum) {
//       case InSightsDateEnum.today:
//         return DateTimeRange(start: DateTime.now(), end: DateTime.now());
//       case InSightsDateEnum.yesterday:
//         return DateTimeRange(
//             start: DateTime.now().subtract(const Duration(days: 1)),
//             end: DateTime.now());
//       case InSightsDateEnum.last7Days:
//         return DateTimeRange(
//             start: DateTime.now().subtract(const Duration(days: 7)),
//             end: DateTime.now());
//       case InSightsDateEnum.last15Days:
//         return DateTimeRange(
//             start: DateTime.now().subtract(const Duration(days: 15)),
//             end: DateTime.now());
//       case InSightsDateEnum.last30Days:
//         return DateTimeRange(
//             start: DateTime.now().subtract(const Duration(days: 30)),
//             end: DateTime.now());
//     }
//   }
// }


class InSightsCubit extends Cubit<InSightsState> {
  InSightsCubit() : super(const InSightsInitialState());

  final _inSightsRepo = InSightsRepo();

  Future<void> getInSights({
    bool isLoading = false,
    required int smeId,
    DateTimeRange? selectedDateTimeRange,
    InSightsDateEnum? inSightsDateEnum,
  }) async {
    try {
      if (isLoading) {
        emit(const InSightsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
      }

      final dateTimeRange = selectedDateTimeRange ??
          _getDateTimeRange(inSightsDateEnum ?? InSightsDateEnum.today);

      // 🔹 Call both APIs in parallel
      final results = await Future.wait([
        _inSightsRepo.getInsight(
          startDate: dateTimeRange.start,
          endDate: dateTimeRange.end,
          smeId: smeId,
        ),
        _inSightsRepo.getDispositionSummary(
          smeId: smeId,
          startDate: dateTimeRange.start,
          endDate: dateTimeRange.end,
        ),
      ]);

      final insightRes = results[0];
      final dispositionRes = results[1];

      if (insightRes.isSuccess && dispositionRes.isSuccess) {
        emit(
          InSightsSuccessState(
            insightsResponse:
                InsightsResponse.fromJson(insightRes.data[0]),
            dispositionSummary:
                DispositionSummaryResponse.fromJson(dispositionRes.data),
            dateTimeRange: dateTimeRange,
            inSightsDateEnum: inSightsDateEnum,
          ),
        );
      } else {
        emit(const InSightsErrorState());
       FToastManager().showToast(
  message: insightRes.isSuccess
      ? dispositionRes.message
      : insightRes.message,
);

      }
    } on AppDioException catch (e) {
      emit(const InSightsErrorState());
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      emit(const InSightsErrorState());
      FToastManager().showToast(
        message: AppLocalizations.of(
          AppKeys.navigatorKey.currentContext!,
        )!
            .somethingWentWrong,
      );
      debugPrint("InSightsCubit $e");
      debugPrint("$s");
    } finally {
      if (!isLoading) {
        AppLoadingIndicator.dismissLoadingIndicator();
      }
    }
  }

  // DateTimeRange _getDateTimeRange(InSightsDateEnum inSightsDateEnum) {
  //   final now = DateTime.now();
  //   switch (inSightsDateEnum) {
  //     case InSightsDateEnum.today:
  //       return DateTimeRange(start: now, end: now);
  //     case InSightsDateEnum.yesterday:
  //       return DateTimeRange(
  //         start: now.subtract(const Duration(days: 1)),
  //         end: now,
  //       );
  //     case InSightsDateEnum.last7Days:
  //       return DateTimeRange(
  //         start: now.subtract(const Duration(days: 7)),
  //         end: now,
  //       );
  //     case InSightsDateEnum.last15Days:
  //       return DateTimeRange(
  //         start: now.subtract(const Duration(days: 15)),
  //         end: now,
  //       );
  //     case InSightsDateEnum.last30Days:
  //       return DateTimeRange(
  //         start: now.subtract(const Duration(days: 30)),
  //         end: now,
  //       );
  //   }
  // }

  DateTimeRange _getDateTimeRange(InSightsDateEnum inSightsDateEnum) {
  final now = DateTime.now();

  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd =
      todayStart.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));

  switch (inSightsDateEnum) {
    case InSightsDateEnum.today:
      return DateTimeRange(
        start: todayStart,
        end: todayEnd,
      );

    case InSightsDateEnum.yesterday:
      final yesterdayStart = todayStart.subtract(const Duration(days: 1));
      final yesterdayEnd = todayStart.subtract(const Duration(seconds: 1));
      return DateTimeRange(
        start: yesterdayStart,
        end: yesterdayEnd,
      );

    case InSightsDateEnum.last7Days:
      return DateTimeRange(
        start: todayStart.subtract(const Duration(days: 6)),
        end: todayEnd,
      );

    case InSightsDateEnum.last15Days:
      return DateTimeRange(
        start: todayStart.subtract(const Duration(days: 14)),
        end: todayEnd,
      );

    case InSightsDateEnum.last30Days:
      return DateTimeRange(
        start: todayStart.subtract(const Duration(days: 29)),
        end: todayEnd,
      );
  }
}

}
