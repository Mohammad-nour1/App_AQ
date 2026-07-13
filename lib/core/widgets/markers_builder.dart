import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../constants/app_colors.dart';

class MarkersBuilder {
  static userMarker(userCords) =>
      _markerBuilder(location: false, pointCords: userCords);

  static locationMarker(locatinCords) =>
      _markerBuilder(pointCords: locatinCords);

  static _markerBuilder({bool location = true, required pointCords}) {
    return Marker(
      point: pointCords,
      child: Icon(
        location ? Icons.location_on : Icons.my_location,
        color: location ? Colors.blue : AppColors.success,
        size: 25,
      ),
    );
  }
}
