import 'package:flutter/material.dart';

/// Global notifier to control FAB visibility across screens.
final ValueNotifier<bool> fabVisibleNotifier = ValueNotifier<bool>(true);
