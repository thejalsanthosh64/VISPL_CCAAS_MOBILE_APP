// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kommuno/core/common/app_theme/app_theme.dart';
// import 'package:kommuno/core/common/widget/white_label/model/white_label_model.dart';

// class WhiteLabelCubit extends Cubit<WhiteLabelModel?> {
//   WhiteLabelCubit() : super(null);

//   void applyWhiteLabel(WhiteLabelModel model) {
//     if (model.primaryColor != null) {
//       AppColors.appColor = model.primaryColor!;
//     }

//     if (model.secondaryColor != null) {
//       AppColors.secondaryColor = model.secondaryColor!;
//     }

//     // Update gradient too
//     AppColors.homeProgressGradient = LinearGradient(
//       colors: [
//         AppColors.appColor,
//         AppColors.secondaryColor,
//       ],
//     );

//     emit(model);
//   }

//   void reset() {
//     AppColors.appColor = const Color(0xff623e6c);
//     AppColors.secondaryColor = const Color(0xffB76DC9);
//     emit(null);
//   }
// }