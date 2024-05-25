import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/utils/personal_widgets.dart';
import 'package:inventario_home/utils/util_camera.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:inventario_home/routes/routes.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key, required this.title});
  final String title;

  @override
  State<Inventory> createState() => _Inventory();
}

class _Inventory extends State<Inventory> {
  
  Service service = Service();
  WidgetState _state = WidgetState.NONE;
  bool _isSelected = false;

  @override
  void initState(){
    super.initState(); 
    _state = WidgetState.LOADED;
       
  }

  void seleccionado(int index){
    setState(() {
      UtilsService.productos[index].setSelection(true);
    });
  }

  void deselected(int index){
    setState(() {
      UtilsService.productos[index].setSelection(false);
    });
  }


  Widget buildScaffold(BuildContext context, Widget body){
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventario"),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.scanner);
        },
        child: Icon(Icons.qr_code),
      ),
      
      
    );
  }

  

  Widget circularProgress(){
    return Center(child: CircularProgressIndicator());
  }

  

  Widget contentProduct(){
    return ListView.builder(
      itemCount: UtilsService.productos.length,
      itemBuilder: (context, index){
        return Card(
          color: UtilsService.productos[index].getSelection() ? Colors.red : Colors.blue,//Necesito que esto se convierta en una lista
          child: GestureDetector(
            onTap:() => deselected(index),
            onLongPress: () => seleccionado(index),
            child: ListTile(
              title: Text("${UtilsService.productos[index].getTitle()}"),
              trailing: Text("${UtilsService.cantidadPorProducto[UtilsService.productos[index].getId().toString()]}",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                        ),
              leading: Image.network(UtilsService.productos[index].getImage()),
            ),
          ),
        );
      });
  }

  

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return buildScaffold(
          context, 
          circularProgress()
        );
      case WidgetState.ERROR:
      case WidgetState.LOADED:
        return buildScaffold(
          context, 
          contentProduct());
    }
  }

   
}