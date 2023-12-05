import 'package:flutter/material.dart';

class bottomMenu extends StatelessWidget{

  Function(int indice)? onTap;

  bottomMenu({Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(onPressed: () => onTap!(0), child: Icon(Icons.list,color: Colors.black,)),
          IconButton(onPressed: () => onTap!(1), icon: Image.asset("assets/phone/smiley.gif",height: 25, width: 25)),
          TextButton(onPressed: () => onTap!(2), child: Icon(Icons.grid_view,color: Colors.black,)),
        ]
    );
  }

  void tapAction(int indice){
    print(indice.toString());
  }

  void btnTap1(){
    tapAction(0);
  }
  void btnTap2(){
    tapAction(1);
  }
  void btnTap3(){
    tapAction(2);
  }
}