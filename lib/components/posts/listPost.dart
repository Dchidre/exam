import 'package:exa_chircea/components/customIconBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Singletone/DataHolder.dart';

class ListPost extends StatelessWidget {
  final String sUserName;
  final String sAvatar;
  final int iPos;
  final String urlImg;
  final Function(int indice)? onPostTap;

  const ListPost({
    Key? key,
    required this.sUserName,
    required this.sAvatar,
    required this.iPos,
    this.urlImg = "",
    required this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onPostTap!(iPos);
          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(sAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(sUserName),
                    ],
                  ),
                ),
                Container(
                  width: DataHolder().platformAdmin.getScreenWidth() * 0.85,
                  height: DataHolder().platformAdmin.getScreenWidth() * 0.85, // Ajuste de la altura del contenedor principal
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(urlImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio entre el contenido y el botón de comentarios
                Align(
                  alignment: Alignment.centerLeft, // Alineación a la izquierda
                  child: customIconBtn(icono: Icon(Icons.comment), fAction: () {}),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
