import 'package:flutter/cupertino.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.radius,
    this.color,
  });

  final double? radius;

  final Color? color;

  static OverlayEntry? _overlayEntry;

  static bool _isLoading = false;

  static bool get isLoading => _isLoading;

  static void showLoadingIndicator({
    double? radius,
    Color? color,
  }) {
    if (!_isLoading) {
      _isLoading = true;
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: AbsorbPointer(
            absorbing: true,
            child: Container(
              color: AppColors.black.withValues(alpha: 0.5),
              child: AppLoadingIndicator(
                radius: radius ?? 30,
                color: color ?? AppColors.white,
              ),
            ),
          ),
        ),
      );
      Overlay.of(AppKeys.navigatorKey.currentContext!).insert(_overlayEntry!);
    }
  }

  static void dismissLoadingIndicator() {
    if (_isLoading) {
      _isLoading = false;
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: color ?? AppColors.appColor,
        radius: radius ?? 20,
      ),
    );
  }
}
