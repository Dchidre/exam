import 'package:cloud_firestore/cloud_firestore.dart';

class fbPost{

  final String sUserName;
  final String titulo;
  final String cuerpo;
  final String sUrlImg;

  fbPost ({
    required this.sUserName,
    required this.titulo,
    required this.cuerpo,
    required this.sUrlImg,
  });

  factory fbPost.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return fbPost(
      titulo: data?['titulo'],
      cuerpo: data?['cuerpo'],
      sUrlImg: data?['sUrlImg'] != null ? data!['sUrlImg'] : "https://imgv3.fotor.com/images/cover-photo-image/a-beautiful-girl-with-gray-hair-and-lucxy-neckless-generated-by-Fotor-AI.jpg",
      sUserName: data?['sUserName'],
      //si no hay imagen, que muestre otra cosa
      //NO ME ACEPTA LA IMAGEN
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (titulo != null) "titulo": titulo,
      if (cuerpo != null) "cuerpo": cuerpo,
      if (sUrlImg != null) "sUrlImg": sUrlImg,
      if (sUserName != null) "sUserName": sUserName,
    };
  }
}