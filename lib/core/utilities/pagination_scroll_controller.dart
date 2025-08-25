import 'package:flutter/material.dart';

class PaginationScrollController {
  late ScrollController scrollController;
  bool _isLoading = false;
  late Future<bool> Function() _loadAction;

  bool hasMoreData = true;

  void init({required Future<bool> Function() loadAction}) {
    _loadAction = loadAction;
    scrollController = ScrollController()..addListener(scrollListener);
  }

  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  void scrollListener() {
    if (hasMoreData) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _isLoading = true;
        _loadAction().then((shouldStop) {
          hasMoreData = shouldStop;
          _isLoading = false;
        });
      }
    }
  }
}
