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
  bool _isLogin =true;

  /// Call this once after login
void start({
  required String username,
  required String role,
  required bool isLogin,
}) {
  //  Prevent duplicate starts
  if (_isRunning) {
    debugPrint("SetIsAlive already running — skipping start");
    return;
  }

  _username = username;
  _role = role;
  _isLogin = isLogin;

  WidgetsBinding.instance.addObserver(this);
  _startTimer();
}


  /// Stop call on logout
  void stop() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    _username = null;
    _role = null;
        _isLogin = true;

  }


void _startTimer() {
  if (_isRunning || _username == null || _role == null) return;

  debugPrint("SetIsAlive started");
  _isRunning = true;

  // send immediately
  _sendAlive();

  //  every 5 seconds
  _timer = Timer.periodic(const Duration(seconds: 5), (_) {
    _sendAlive();
  });
}

Future<void> sendLogin({
    required String username, required String role,
  }) async {
    try {
      debugPrint("Sending SetIsAlive LOGIN");
      await ActivityHelperRepo().setIsAlive(
        username: username,
        mode: role,
      );
      debugPrint("SetIsAlive LOGIN sent");
    } catch (e) {
      debugPrint("SetIsAlive LOGIN failed: $e");
    }
  }

Future<void> _sendAlive() async {
  try {
    await ActivityHelperRepo().setIsAlive(
      username: _username!,
      mode: "interval",
      role: _role!,
      isWebrtcUser: 0,
    );
    debugPrint("SetIsAlive INTERVAL sent");
  } catch (e) {
    debugPrint("SetIsAlive INTERVAL failed: $e");
  }
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
    } 
  }
}
