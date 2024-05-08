

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
  Marker marker = Marker(
    markerId: MarkerId('id-1'),
    position: LatLng(37.42796133580664, -122.085749655962),
    infoWindow: InfoWindow(title: 'Initial Marker'),
  );


  @override
  void initState() {
    super.initState();
    print("-------------->>>>>>>>>>>>>>>>>  ${DataHolder().user.pos.latitude}       ${DataHolder().user.pos.longitude}");
    _posUser = CameraPosition(
        target: LatLng(DataHolder().user.pos.latitude,
                        DataHolder().user.pos.longitude),
        zoom: 18
    );
    DataHolder().listenPosChange(changePosPhone);
  }

  void changePosPhone(Position? position) {
    print("------------------>>>>>>>>>>>>>>   ${position}");
    setState(() {
      marker = marker.copyWith(
        positionParam: LatLng(position!.latitude,position.longitude)
      );
    });
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
        initialCameraPosition: _posUser,
        markers: {marker},
      ),
    );
  }
}