import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AlphabeticList extends StatelessWidget {
  const AlphabeticList({super.key, required this.items, this.scrollController});

  final Iterable<AlphabetListViewItemGroup> items;

  final ScrollController? scrollController;

  static const unNamedSign = "#";

  @override
  Widget build(BuildContext context) {
    return AlphabetListView(
      scrollController: scrollController,
      items: items,
      options: AlphabetListViewOptions(
        listOptions: ListOptions(
          physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          stickySectionHeader: false,
          listHeaderBuilder: (context, symbol) {
            return Container(
              color: AppColors.appColor,
              padding: EdgeInsets.only(
                  left: AppConstant.kCenterPadding,
                  bottom: AppConstant.kCenterPadding),
              alignment: Alignment.centerLeft,
              child: Text(
                symbol,
                style: AppTextStyle.white16,
              ),
            );
          },
        ),
        scrollbarOptions:
            const ScrollbarOptions(padding: EdgeInsets.zero, width: 20),
        overlayOptions: OverlayOptions(
          showOverlay: true,
          alignment: Alignment.topRight,
          overlayBuilder: (ctx, text) {
            return Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.5),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: AppTextStyle.black25,
              ),
            );
          },
        ),
      ),
    );
  }
}
