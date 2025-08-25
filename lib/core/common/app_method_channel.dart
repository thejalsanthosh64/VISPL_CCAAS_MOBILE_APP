import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


abstract class AppMethodChannel {
  static const methodChannel = MethodChannel("com.kommuno");

  static const makePhoneCall = "makePhoneCall";

  static const initialise = "initialise";

  static Future<void> makeDirectCall({required String number}) async {
    try {
      final res =  await methodChannel.invokeMethod(makePhoneCall, number);
      debugPrint("makeDirectCall $res");
    } on PlatformException {
      rethrow;
    }
  }

  static Future<void> initialiseApp() async {
    try {
      final res = await methodChannel.invokeMethod(initialise);
      debugPrint("initialiseApp $res");
      setAppMethodCallHandler();
    } on PlatformException {
      rethrow;
    }
  }

  static Future<void> setAppMethodCallHandler() async {
    try {
      methodChannel.setMethodCallHandler(_handleMethod);
    } on PlatformException {
      rethrow;
    }
  }

  static Future<void> _handleMethod(MethodCall call) async {
    try {
      debugPrint(
          "setAppMethodCallHandler _handleMethod ${call.method} ${call.arguments}");
    } catch (e, s) {
      debugPrint("_handleMethod exception $e");
      debugPrint("$s");
    }
  }
}
