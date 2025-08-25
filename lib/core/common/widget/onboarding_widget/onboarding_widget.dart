import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

part 'dot_indicator.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({
    super.key,
    required this.content,
  });

  final List<Widget> content;

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late PageController _pageController;
  final _pageIndex = ValueNotifier<int>(0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageIndex.value < widget.content.length - 1) {
        _pageIndex.value = _pageIndex.value + 1;
      } else {
        _pageIndex.value = 0;
      }
      _pageController.animateToPage(
        _pageIndex.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _pageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _pageIndex,
      builder: (__, pageIndex, ch) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  _pageIndex.value = index;
                },
                itemCount: widget.content.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: widget.content[index],
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstant.kSized5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.content.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: DotIndicator(
                    isActive: index == pageIndex,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
