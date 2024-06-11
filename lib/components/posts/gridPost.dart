import 'package:flutter/material.dart';
import '../../Singletone/DataHolder.dart';
import '../customIconBtn.dart';

class GridPost extends StatelessWidget {
  final String sUserName;
  final String sAvatar;
  final int iPos;
  final String urlImg;
  final Function(int indice)? onPostTap;

  const GridPost({
    Key? key,
    required this.sUserName,
    required this.sAvatar,
    required this.iPos,
    this.urlImg = "",
    required this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(sAvatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      sUserName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(urlImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0), // Espacio entre la imagen y los botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customIconBtn(icono: Icon(Icons.edit, color: Colors.white), fAction: () {}),
                customIconBtn(icono: Icon(Icons.chat, color: Colors.white), fAction: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
