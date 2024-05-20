

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/Singletone/DataHolder.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseFirestore db = FirebaseFirestore.instance;
  LatLng? _center;
  Marker markerPrincipal = Marker(
    markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid),
    position: LatLng(
        DataHolder().user.pos.latitude, DataHolder().user.pos.longitude),
    infoWindow: InfoWindow(title: DataHolder().user.name),
  );
  Set<Marker> markerSet = Set();
  final Map<String, fbUser> userTable = Map();

  //--->INICIOS<---
  //inicia el GeoLocator
  void loadGeoLocator() async {
    Position pos = await DataHolder().geolocAdmin.determinePosition();
  }

  //inicia el mapa (antes del widget ya ve donde esta el usuario) y va escuchando los cambios que se hacen en el
  @override
  void initState() {
    print("-------------->>>>>>>>>>>>>>>>>  ${DataHolder().user.pos
        .latitude}       ${DataHolder().user.pos.longitude}");
    _posUser = CameraPosition(
        target: LatLng(DataHolder().user.pos.latitude,
            DataHolder().user.pos.longitude),
        zoom: 18
    );
    DataHolder().listenPosChange(changePosPhone);
    downloadUsers();
    super.initState();
  }

  //inicia el controlador
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  //--->ESCUCHA<---
  //metodo para que se vayan escuchando los cambios de pos del telefono
  void changePosPhone(Position? position) {
    print("------------------>>>>>>>>>>>>>>   ${position}");
    setState(() {
      markerPrincipal = markerPrincipal.copyWith(
          positionParam: LatLng(position!.latitude, position.longitude));
      markerSet.add(markerPrincipal);
    });
  }

  //--->DESCARGA TODOS LOS USERS<---
  void downloadUsers() async {
    CollectionReference<fbUser> ref = db.collection("Usuarios")
        .withConverter(fromFirestore: fbUser.fromFirestore,
      toFirestore: (fbUser user, _) => user.toFirestore(),);

    ref.snapshots().listen((readyUsers), onError: downloadUsersError);
  }
  void downloadUsersError(error) {
    print("Listen failed: $error");
  }

  void readyUsers(QuerySnapshot<fbUser> querySnapshot) {
    print("NUM USERS UPDATED ------------>>> " + querySnapshot.docChanges.length.toString());

    Set<Marker> markerSetTemp = Set();

    for (int i = 0; i < querySnapshot.docChanges.length; i++) {
      fbUser temp = querySnapshot.docChanges[i].doc.data()!;
      userTable[querySnapshot.docChanges[i].doc.id] = temp;

      Marker tempMarker = Marker(
        markerId: MarkerId(querySnapshot.docChanges[i].doc.id),
        position: LatLng(
            temp.pos.latitude, temp.pos.longitude),
        infoWindow: InfoWindow(title: temp.name),
      );

      markerSetTemp.add(tempMarker);
    }

    setState(() {
      markerSet.addAll(markerSetTemp);
    });
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _posUser,
          markers: markerSet,
        ),
      );
    }
  }