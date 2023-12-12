import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Singletone/DataHolder.dart';

class listPost extends StatelessWidget{

  final String sUserName;
  final String sAvatar;
  final int iPos;
  final String urlImg;
  final Function(int indice)? onPostTap;

  const listPost({super.key,
    required this.sUserName,
    required this.sAvatar,
    required this.iPos,
    this.urlImg = "",
    required this.onPostTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Column(
        children: [
          InkWell(//para poder poner onTap
            onTap: () {onPostTap!(iPos);},
            child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.all(20.0),
                      child:
                        Row(
                          children: [
                            Container(
                              width: DataHolder().platformAdmin.getScreenWidth() * 0.15,
                              height: DataHolder().platformAdmin.getScreenWidth() * 0.15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    opacity: 1,
                                    image: NetworkImage(sAvatar),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            SizedBox(width: DataHolder().platformAdmin.getScreenWidth() * 0.035),
                            Text(sUserName),
                          ],
                        ),
                    ),
                    Container(
                      width: DataHolder().platformAdmin.getScreenWidth(),
                      height: DataHolder().platformAdmin.getScreenWidth(),
                      decoration: BoxDecoration(
                      image: DecorationImage(
                      opacity: 1,
                      image: NetworkImage(urlImg),
                      fit: BoxFit.cover,
                      )
                      ),
                    ),
                   ]
            )
            )
        ]
      );
  }
}