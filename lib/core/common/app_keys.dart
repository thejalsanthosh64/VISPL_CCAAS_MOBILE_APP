
import 'package:flutter/material.dart';

abstract class AppKeys {

  static final navigatorKey = GlobalKey<NavigatorState>();

  static final nestedNavigatorKey = GlobalKey<NavigatorState>();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static const materialAppKey = ValueKey<String>("MaterialApp");
  
}