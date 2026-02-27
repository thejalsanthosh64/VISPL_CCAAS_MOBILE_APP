import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class CallsInfoContainer extends StatelessWidget {
  const CallsInfoContainer(
      {super.key, required this.title, this.count, this.color});

  final String title;
  final num? count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.appColor),
      ),
      child: Column(

mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
             maxLines: 2,                
            overflow: TextOverflow.ellipsis,
             textAlign: TextAlign.center,
            style: color != null
                ? AppTextStyle.whiteNormal
                : AppTextStyle.appColorNormal,
          ),
          Text(
            "${count ?? "0"}",
            style:
                color != null ? AppTextStyle.white23 : AppTextStyle.appColor23,
          ),
        ],
      ),
    );
  }
}
