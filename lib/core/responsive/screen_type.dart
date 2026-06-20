enum ScreenType {
  mobile,
  tablet,
  desktop,
}

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1024;
  static const double desktopMin = 1025;
  static const double largeContentMaxWidth = 1320;
}
