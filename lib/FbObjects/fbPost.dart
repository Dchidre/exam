import 'package:cloud_firestore/cloud_firestore.dart';

class fbPost{

  final String sUserName;
  final String title;
  final String body;
  final String sUrlImg;

  fbPost ({
    required this.sUserName,
    required this.title,
    required this.body,
    required this.sUrlImg,
  });

  factory fbPost.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return fbPost(
      title: data?['title'] ?? '',
      body: data?['body'] ?? '',
      sUrlImg: data?['sUrlImg'] ?? '',
      sUserName: data?['sUserName'] ?? '',
      //si no hay imagen, que muestre otra cosa
      //NO ME ACEPTA LA IMAGEN
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "body": body,
      "sUrlImg": sUrlImg,
      "sUserName": sUserName,
    };
  }
}