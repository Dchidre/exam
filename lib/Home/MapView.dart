

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
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
    downloadUsers();
    super.initState();
  }

  //inicia el controlador
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
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
  void readyUsers(QuerySnapshot<fbUser> querySnapshot) async {
    print("NUM USERS UPDATED ------------>>> " + querySnapshot.docChanges.length.toString());

    Set<Marker> markerSetTemp = Set();

    for (int i = 0; i < querySnapshot.docChanges.length; i++) {
      fbUser temp = querySnapshot.docChanges[i].doc.data()!;
      userTable[querySnapshot.docChanges[i].doc.id] = temp;

      BitmapDescriptor customIcon = await _getBitmapDescriptorFromUrl(temp.sAvatar);

      Marker tempMarker = Marker(
        markerId: MarkerId(querySnapshot.docChanges[i].doc.id),
        position: LatLng(temp.pos.latitude, temp.pos.longitude),
        infoWindow: InfoWindow(title: temp.name),
        icon: customIcon,
      );

      markerSetTemp.add(tempMarker);
    }

    setState(() {
      markerSet.addAll(markerSetTemp);
    });
  }
  Future<Uint8List> _resizeImage(Uint8List data, int width, int height) async {
    return await FlutterImageCompress.compressWithList(
      data,
      minWidth: width,
      minHeight: height,
      quality: 100,
      format: CompressFormat.png,
    );
  }
  Future<Uint8List> _cropToCircle(Uint8List imageData) async {
    final img.Image image = img.decodeImage(imageData)!;
    final int diameter = image.width < image.height ? image.width : image.height;
    final img.Image croppedImage = img.copyResizeCropSquare(image, diameter);

    final img.Image circularImage = img.Image(diameter, diameter);
    final int radius = diameter ~/ 2;

    for (int y = 0; y < diameter; y++) {
      for (int x = 0; x < diameter; x++) {
        final int dx = x - radius;
        final int dy = y - radius;
        if (dx * dx + dy * dy <= radius * radius) {
          circularImage.setPixel(x, y, croppedImage.getPixel(x, y));
        }
      }
    }

    return Uint8List.fromList(img.encodePng(circularImage));
  }
  Future<BitmapDescriptor> _getBitmapDescriptorFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final resizedData = await _resizeImage(response.bodyBytes, 200, 200);
        final circularData = await _cropToCircle(resizedData);
        return BitmapDescriptor.fromBytes(circularData);
      } else {
        return BitmapDescriptor.defaultMarker; // Fallback icon if the download fails
      }
    } catch (e) {
      return BitmapDescriptor.defaultMarker; // Fallback icon if there's an error
    }
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