import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/FbObjects/fbUser.dart';
import 'package:exa_chircea/Singletone/DataHolder.dart';
import 'package:exa_chircea/components/customBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../components/textField.dart';

class webProfileDialog {

  @override
  Future<Object?> showWebProfileDialog(BuildContext context) {

    //var
    FirebaseFirestore db = FirebaseFirestore.instance;
    final tecName = TextEditingController();
    final tecAge = TextEditingController();
    final tecRepPassword = TextEditingController();
    String? address;
    Position? pos;


    //methods
    Future<bool> _handleLocationPermission() async {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return Geolocator.isLocationServiceEnabled();
    }
    Future<void> _getCurrentPosition() async {
      try {
        pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        print("Error getting current position: $e");
      }
    }
    Future<void> createProfile(BuildContext context) async {
      // Ensure location permission
      if (!await _handleLocationPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission not granted. Profile creation failed.')),
        );
        return;
      }

      // Fetch current position
      await _getCurrentPosition();

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(pos!.latitude, pos!.longitude);
      String address = placemarks.isNotEmpty ? (placemarks[0].street! + ", " + placemarks[0].locality! + ", " + placemarks[0].country!) ?? 'Unknown' : 'Unknown';

      // Generate profile data
      /*Map<String, dynamic> profileData = {
        "name": tecName.text,
        "age": int.tryParse(tecAge.text) ?? 0, // Safely parse age to int
        "sAvatar": "https://ih1.redbubble.net/image.1046392292.3346/st,medium,507x507-pad,600x600,f8f8f8.jpg",
        "pos": pos != null ? GeoPoint(pos!.latitude, pos!.longitude) : null,
        "address": address,
      };*/



      DataHolder().user=fbUser(name: tecName.text, age: int.tryParse(tecAge.text) ?? 0,
          sAvatar: "https://ih1.redbubble.net/image.1046392292.3346/st,medium,507x507-pad,600x600,f8f8f8.jpg",
          pos: pos != null ? GeoPoint(pos!.latitude, pos!.longitude) : const GeoPoint(0, 0), address: address);

      try {
        // Set the profile data
        String uidUsuario = FirebaseAuth.instance.currentUser!.uid;
        await db.collection("Usuarios").doc(uidUsuario).set(DataHolder().user.toFirestore());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
        Navigator.of(context).popAndPushNamed('/homeView');
      } catch (e) {
        print("Error creating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create profile. Please try again later.')),
        );
      }
    }
    void onClickCreateProfile(BuildContext context) async{
      createProfile(context);
      Navigator.of(context).popAndPushNamed('/homeView');
    }


    //paint
    return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        /*
        Left-to-Right (Leftwards): (x: -1.0, y: 0.0) - This moves from left to right.
        Right-to-Left (Rightwards): (x: 1.0, y: 0.0) - Moves from right to left.
        Top-to-Bottom (Downwards): (x: 0.0, y: -1.0) - Slides from top to bottom.
        Bottom-to-Top (Upwards): (x: 0.0, y: 1.0) - Moves from bottom to top.
        */

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
      barrierDismissible: true,
      barrierLabel: "profile",
      context: context,
      pageBuilder: (context, _, __) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          height: 620,
          width: 500,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      //title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:
                          Text(
                            "Set up your profile!",
                            style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
                          ),
                      ),
                      SizedBox(height: 50,),
                      //form
                      textField(sLabel: 'Name', myController: tecName, icIzq: Icons.mail_outline),
                      textField(sLabel: 'Age', myController: tecAge, icIzq: Icons.lock_open_outlined),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customBtn(fAction: () {onClickCreateProfile(context);}, sText: "Create"),
                          SizedBox(width: 40,),
                          customBtn(fAction: () {Navigator.of(context).pop();}, sText: "Cancel"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
