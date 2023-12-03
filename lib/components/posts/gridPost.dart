import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Singletone/DataHolder.dart';

class gridPost extends StatelessWidget{

  final String sUserName;
  final int iPos;
  final String urlImg;
  final Function(int indice)? onPostTap;

  const gridPost({super.key,
    required this.sUserName,
    required this.iPos,
    this.urlImg = "",
    required this.onPostTap});


  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
            InkWell( //para poder poner onTap
                onTap: () {onPostTap!(iPos);},
                child:
                Row(
                  children: [
                    Container(
                      width: DataHolder().platformAdmin.getScreenWidth() * 0.03,
                      height: DataHolder().platformAdmin.getScreenWidth() * 0.03,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(width: DataHolder().platformAdmin.getScreenWidth() * 0.01),
                    Text(sUserName),
                  ],
                )
            ),
          ),
          Flexible(
            child:
              Container(
                width: DataHolder().platformAdmin.getScreenWidth() * 0.2,
                height: DataHolder().platformAdmin.getScreenWidth() * 0.2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      opacity: 1,
                      image: NetworkImage(urlImg),
                      fit: BoxFit.cover,
                    )
                ),
              ),
          )
        ],
      );
  }
}
