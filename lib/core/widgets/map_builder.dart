import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

FlutterMap mapBuilder({
  required Function markerLayerBuilder,
  Function? polyLayerBuilder,
  required mapController,
  required LatLng focusCords,
  required double initZoomLevel,
  void Function()? onMapReady,
}) {
  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      initialCenter: LatLng(focusCords.latitude, focusCords.longitude),
      initialZoom: initZoomLevel,
      minZoom: 6.0,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

        userAgentPackageName: 'com.myrealbusinessname.mapsapp',
      ),
      markerLayerBuilder(),
      if (polyLayerBuilder != null) polyLayerBuilder(),
    ],
  );
}
