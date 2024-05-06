

import 'dart:ffi';

import 'package:exa_chircea/Singletone/DataHolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../FbObjects/fbUser.dart';

class MapaView extends StatefulWidget {
  @override
  State<MapaView> createState() => _MapViewState();
}

class _MapViewState extends State<MapaView> {

  late GoogleMapController mapController;
  late fbUser user;
  late CameraPosition _posUser;
  LatLng? _center;


  @override
  void initState() {
    super.initState();
    _posUser = CameraPosition(
        target: LatLng(DataHolder().user.pos.latitude,
                        DataHolder().user.pos.longitude),
        zoom: 18
    );
    DataHolder().listenPosChange();
  }

  void loadGeoLocator() async {
    Position pos = await DataHolder().geolocAdmin.determinePosition();
  }

  Future<void> fetchUser() async {
    fbUser currentUser = await DataHolder().fbAdmin.getCurrentUser();
    setState(() {
      user = currentUser;
      _center = LatLng(DataHolder().user.pos.latitude, DataHolder().user.pos.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _posUser
      ),
    );
  }
}