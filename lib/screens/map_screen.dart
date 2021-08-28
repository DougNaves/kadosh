import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  _onMapCreated (GoogleMapController controller){
    _controller.complete(controller);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-19.902690062131636, -43.90278780209041),
    zoom: 16,
  );

  static final CameraPosition _kadosh = CameraPosition(
      bearing: 180,
      target: LatLng(-19.902690062131636, -43.90278780209041),
      tilt: 45,
      zoom: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,

      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _eKadosh,
        label: Text('Espaço Kadosh'),
        icon: Icon(Icons.zoom_in),
        backgroundColor: Theme.of(context).primaryColor,

      ),
    );
  }

  Future<void> _eKadosh() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kadosh));
  }
}

