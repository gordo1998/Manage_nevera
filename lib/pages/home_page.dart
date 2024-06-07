import 'package:flutter/material.dart';
import 'package:inventario_home/pages/camera_site.dart';
import 'package:inventario_home/pages/inventory.dart';
import 'package:inventario_home/pages/lista_compra.dart';
import 'package:inventario_home/pages/scanner.dart';
import 'package:inventario_home/routes/app_routes.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:inventario_home/utils/personal_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _selectIndex = 1;

  List<Widget> paginas = [
    Scanner(title: "Scanner"),
    Inventory(title: "Inventory"),
    ListaCompra(title: "Compra"),
    
  ];
  
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: MyColors.AZULMUYOSCURO,
      ),
      body: paginas[_selectIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.AZULMUYOSCURO,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Scanner"
          ),
            
          BottomNavigationBarItem(
            backgroundColor: MyColors.BLANCOAMARILLESCO,
            icon: Icon(Icons.inventory),
            label: "Inventario"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Lista"

          )
        ],
        currentIndex: _selectIndex,
        selectedItemColor: MyColors.BLANCOAMARILLESCO,
        unselectedItemColor: MyColors.AZULOSCURO,
        onTap: _onItemTapped,
       
      )
      
    );
  }

  void _onItemTapped(int index){
    setState(() {
      _selectIndex = index;
      //navigate(index, context);
    });
  }
}