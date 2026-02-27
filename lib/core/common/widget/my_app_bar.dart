import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/generated/assets.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.onTapLeading,
    this.leading,
  });

  final String? title;
  final List<Widget> actions;
  final VoidCallback? onTapLeading;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          (ModalRoute.of(context)?.impliesAppBarDismissal ?? false
              ? InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTapLeading ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child:  Padding(
                    padding: const EdgeInsets.only(
                        left: AppConstant.kBodyHorizontalPadding),
                    child: AppAvatar(
                      backgroundColor: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 15,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                  ),
                )
              : null),
      leadingWidth: 50,
      centerTitle: false,
      actions: [...actions, const SizedBox(width: 7)],
      title: Text(title ?? ''),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          Assets.imagesAppBarBg,
          fit: BoxFit.cover,
          color: AppColors.appColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
