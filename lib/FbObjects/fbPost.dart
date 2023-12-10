import 'package:cloud_firestore/cloud_firestore.dart';

class fbPost{

  final String sUserName;
  final String title;
  final String body;
  final String sUrlImg;
  final String idPost;
  final String idUser;

  fbPost ({
    required this.idPost,
    required this.idUser,
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
      idPost: data?['idPost'] ?? '',
      idUser: data?['idUser'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "body": body,
      "sUrlImg": sUrlImg,
      "sUserName": sUserName,
      "idPost": idPost,
      "idUser": idUser,
    };
  }

  fbPost copyWith({
    String? idPost,
    String? idUser,
    String? sUserName,
    String? title,
    String? body,
    String? sUrlImg,
  }) {
    return fbPost(
      idPost: idPost ?? this.idPost,
      idUser: idUser ?? this.idUser,
      sUserName: sUserName ?? this.sUserName,
      title: title ?? this.title,
      body: body ?? this.body,
      sUrlImg: sUrlImg ?? this.sUrlImg,
    );
  }
}