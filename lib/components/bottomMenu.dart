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
          TextButton(onPressed: () => onTap!(0), child: Icon(Icons.home,color: Colors.black,)),
          TextButton(onPressed: () => onTap!(1), child: Icon(Icons.search,color: Colors.black,)),
          IconButton(onPressed: () => onTap!(2), icon: Image.asset("assets/phone/drawerGIF.gif",height: 35, width: 35)),
          TextButton(onPressed: () => onTap!(3), child: Icon(Icons.person,color: Colors.black,)),
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
  void btnTap4(){
    tapAction(3);
  }
}