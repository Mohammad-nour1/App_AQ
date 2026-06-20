import 'package:flutter/widgets.dart';
import 'screen_type.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, ScreenType screenType, double width) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenType = _getScreenType(width);
        return builder(context, screenType, width);
      },
    );
  }

  static ScreenType _getScreenType(double width) {
    if (width < AppBreakpoints.tabletMin) {
      return ScreenType.mobile;
    } else if (width <= AppBreakpoints.tabletMax) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }
}
