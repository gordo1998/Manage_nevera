import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/utils/utils_service.dart' as UService;
import 'package:inventario_home/routes/routes.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key, required this.title});
  final String title;

  @override
  State<Inventory> createState() => _Inventory();
}

class _Inventory extends State<Inventory> {
  
  Service service = Service();
  UService.WidgetState _state = UService.WidgetState.NONE;
  //WidgetState _state = WidgetState.NONE;
  bool _isSelected = false;

  @override
  void initState(){
    super.initState(); 
    _state = UService.WidgetState.LOADED;
       
  }

  void seleccionado(int index){
    setState(() {
      UService.UtilsService.productos[index].setSelection(true);
      _isSelected = true;
    });
  }

  void deselected(int index){
    setState(() {
      UService.UtilsService.productos[index].setSelection(false);
      _isSelected = UService.UtilsService.productos.any((producto) => producto.getSelection() == true);
    });
  }


  Widget buildScaffold(BuildContext context, Widget body){
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventario"),
        actions: <Widget>[
          _isSelected ? eliminarAllProducts() : Icon(Icons.abc_sharp),
        ],
      ),
      body: body,
      floatingActionButton: _isSelected ? selectDelete(true) : selectDelete(false),
      
      
    );
  }
  //Itera todos los productos en la lista. Si el producto está seleccionado y su cantidad es menor a 1 se eliminará de la lista.
  //Si el producto no es menor a 1 se le restará la cantidad de producto.
  eliminarProduct(){
    for(Product product in UService.UtilsService.productos){
      if (product.getSelection()){//si el producto está seleccionado
        if (product.getCantidad() < 1){//Si el producto es menor a 1
          setState(() {
          UService.UtilsService.productos.remove(product);
          
          });     
        }else{
          setState(() {
            product.restCantidad();
          });
        } 
      }
    }
  }

  Widget eliminarAllProducts(){
    return GestureDetector(
      onTap: (){
        List<Product> listCompra = UService.UtilsService.productos.where((p) => p.getSelection() == true).toList();
        addProductsList(listCompra);
        UService.UtilsService.productos.removeWhere((p) => p.getSelection() == true);
        setState(() {_isSelected = false;}); 
      },
      child: Icon(Icons.delete),
    );
  }

  addProductsList(List<Product> productos){
    for(Product p in productos){

    }
  }

  Widget selectDelete(bool selectedProduct){
    switch (selectedProduct){
      case true:
        return ElevatedButton(
          onPressed: () {
              eliminarProduct();
          }, 
          child: Row(
            children: <Widget>[
              Text("delete"),
              Icon(Icons.delete,)
            ],
          )
        );
      case false:
        return SizedBox.shrink();
    }
  }

  

  Widget circularProgress(){
    return Center(child: CircularProgressIndicator());
  }

  

  Widget contentProduct(){
    return ListView.builder(
      itemCount: UService.UtilsService.productos.length,
      itemBuilder: (context, index){
        return Card(
          color: UService.UtilsService.productos[index].getSelection() ? Colors.red : Colors.blue,//Necesito que esto se convierta en una lista
          child: GestureDetector(
            onTap:() => deselected(index),
            onLongPress: () => seleccionado(index),
            child: ListTile(
              title: Text("${UService.UtilsService.productos[index].getTitle()}"),
              trailing: Text("${UService.UtilsService.cantidadPorProducto[UService.UtilsService.productos[index].getId().toString()]}",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                        ),
              leading: Image.network(UService.UtilsService.productos[index].getImage()),
            ),
          ),
        );
      });
  }

  

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case UService.WidgetState.NONE:
      case UService.WidgetState.LOADING:
        return buildScaffold(
          context, 
          circularProgress()
        );
      case UService.WidgetState.ERROR:
      case UService.WidgetState.LOADED:
        return buildScaffold(
          context, 
          contentProduct());
    }
  }

   
}