part of 'onboarding_widget.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.appColor : AppColors.grey,
        border: isActive ? null : Border.all(color: AppColors.appColor),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
