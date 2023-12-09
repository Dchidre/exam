import 'package:cloud_firestore/cloud_firestore.dart';

class fbUser{

  final String name;
  final int age;
  final String sAvatar;

  fbUser ({
    required this.name,
    required this.age,
    required this.sAvatar,
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
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (age != null) "age": age,
      if (sAvatar != null) "sAvatar": sAvatar,
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
      );
    } else {
      // Return a default user in case of no data found
      return fbUser(name: '', age: 0, sAvatar: '');
    }
  }

}