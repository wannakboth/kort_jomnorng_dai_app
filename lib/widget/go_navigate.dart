import 'package:flutter/material.dart';

class GoNavigate {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static get currentContext => navigatorKey.currentState!.context;

  static void pushNamed(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static void pushNamedWithArguments(String routeName, Object arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  static void pushNamedAndRemoveUntil(String routeName) {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  static void pushReplacementNamedWithArguments(
      String routeName, Object arguments) {
    navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    navigatorKey.currentState?.pop();
  }
}
