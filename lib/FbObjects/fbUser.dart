import 'package:cloud_firestore/cloud_firestore.dart';

class fbUser{

  final String name;
  final int age;
  final String sAvatar;
  final GeoPoint pos;
  final String address;

  fbUser ({
    required this.name,
    required this.age,
    required this.sAvatar,
    required this.pos,
    required this.address
  });

  factory fbUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return fbUser(
      name: data?['name'],
      age: data?['age'],
      sAvatar: data?['sAvatar'] ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
      pos: data?['pos'],
      address: data?['address']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (age != null) "age": age,
      if (sAvatar != null) "sAvatar": sAvatar,
      if (pos != null) "pos": pos,
      if (address != null) "address": address,
    };
  }

  static Future<fbUser> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(userId)
        .get();

    Map<String, dynamic>? userData = userSnapshot.data();
    if (userData != null) {
      return fbUser(
        name: userData['name'] ?? '',
        age: userData['age'] ?? 0,
        sAvatar: userData['sAvatar'] ?? '',
        pos: userData['pos'] ?? '',
        address: userData['address'] ?? '',
      );
    } else {
      // Return a default user in case of no data found
      return fbUser(name: '', age: 0, sAvatar: '', pos: GeoPoint(40.4168, 3.7038), address: '-');
    }
  }

}