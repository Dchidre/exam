import 'package:cloud_firestore/cloud_firestore.dart';

class fbUser{

  final String name;
  final int age;

  fbUser ({
    required this.name,
    required this.age,
  });

  factory fbUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return fbUser(
      name: data?['name'],
      age: data?['age'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (age != null) "age": age,
    };
  }

}