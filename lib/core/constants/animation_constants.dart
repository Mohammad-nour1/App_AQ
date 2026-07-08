import 'package:flutter/animation.dart';

class AppDurations {
  AppDurations._();

  static const Duration instant = Duration.zero;
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration slowest = Duration(milliseconds: 1000);

  static const Duration pageTransition = fast;
  static const Duration buttonFeedback = fastest;
  static const Duration snackBar = normal;
  static const Duration dialog = normal;
  static const Duration bottomSheet = slow;
  static const Duration loading = slower;
  static const Duration fadeIn = normal;
  static const Duration fadeOut = fast;
}

class AppCurves {
  AppCurves._();

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
}
