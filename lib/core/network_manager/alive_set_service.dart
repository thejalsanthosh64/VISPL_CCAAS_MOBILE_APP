import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:flutter/widgets.dart';

class AliveService with WidgetsBindingObserver {
  static final AliveService _instance = AliveService._internal();
  factory AliveService() => _instance;
  AliveService._internal();

  Timer? _timer;
  String? _username;
  String? _role;
  bool _isRunning = false;

  /// Call this once after login
  void start({
    required String username,
    required String role,
  }) {
    _username = username;
    _role = role;

    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  /// Stop call on logout
  void stop() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    _username = null;
    _role = null;
  }

  // ------------------------------
  // Internal Timer Logic
  // ------------------------------

  void _startTimer() {
    if (_isRunning || _username == null || _role == null) return;

    debugPrint(" SetIsAlive started");
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        await ActivityHelperRepo().setIsAlive(
          username: _username!,
          role: _role!,
        );
        debugPrint("SetIsAlive ping sent");
      } catch (e) {
        debugPrint(" SetIsAlive failed: $e");
      }
    });
  }

  void _stopTimer() {
    if (!_isRunning) return;

    debugPrint(" SetIsAlive stopped");
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  // ------------------------------
  // App Lifecycle Handling
  // ------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("📱 App resumed → Restart SetIsAlive");
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
               state == AppLifecycleState.inactive ||
               state == AppLifecycleState.detached) {
      debugPrint(" App background → Stop SetIsAlive");
      _stopTimer();
    }
  }
}
