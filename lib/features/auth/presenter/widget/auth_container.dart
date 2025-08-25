import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({
    super.key,
    required this.containerBody,
    this.childrenWithScroll = const [],
    this.endChildren = const [],
    this.onTapIcon,
  });

  final List<Widget> containerBody;
  final List<Widget> childrenWithScroll;
  final List<Widget> endChildren;
  final VoidCallback? onTapIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: AppColors.white),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: containerBody,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 50,
                          bottom: 5,
                          child: InkWell(
                            onTap: onTapIcon,
                            customBorder: const CircleBorder(),
                            child: Material(
                              elevation: 8,
                              color: AppColors.transparent,
                              shape: const CircleBorder(),
                              child: AppAvatar(
                                radius: 30,
                                child: Padding(
                                  padding: Platform.isAndroid
                                      ? EdgeInsets.zero
                                      : const EdgeInsets.only(top: 5),
                                  child: Transform.scale(
                                    scaleX: 1.4,
                                    child: const Icon(
                                      Icons.arrow_right_alt_outlined,
                                      color: AppColors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...childrenWithScroll,
                  ],
                ),
              ),
            ),
          ),
          ...endChildren
        ],
      ),
    );
  }
}
