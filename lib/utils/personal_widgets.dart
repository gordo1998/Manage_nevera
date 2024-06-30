import 'package:flutter/material.dart';
import 'package:inventario_home/models/sessionUser.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:inventario_home/routes/routes.dart';

Widget getNapBar(void Function(int index) onTapItem){
  return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Scanner"
          ),
            
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Inventory"

          )
        ],
        currentIndex: UtilsService.selectIndex,
        selectedItemColor: Colors.blue,
        onTap: onTapItem,
       
  );
}

void navigate(int index, BuildContext context){
  switch(index){
        case 0:
          Navigator.pushNamed(context, Routes.scanner);
          break;
        case 1:
          Navigator.pushNamed(context, Routes.home);
          break;
        case 2:
          Navigator.pushNamed(context, Routes.inventory);
          break;
      }
}

Widget exitSession(BuildContext context){
  SessionUser.instancia.exitSession();
  return GestureDetector(
    onTap: (){
      Navigator.pushReplacementNamed(context, Routes.login);
      //redireccion al loggin sin poder ir hacia atrás.
    },
    child: Icon(Icons.exit_to_app, color: MyColors.BLANCOAMARILLESCO,),
  );
}

