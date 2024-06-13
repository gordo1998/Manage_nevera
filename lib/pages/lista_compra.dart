import 'package:flutter/material.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/models/productos_pagados.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart' as UService;
import 'package:inventario_home/models/productos_lista_compra.dart';

class ListaCompra extends StatefulWidget {
  const ListaCompra({super.key, required this.title});
  final String title;

  @override
  State<ListaCompra> createState() => _ListaCompra();
}

class _ListaCompra extends State<ListaCompra> {

  bool _anyProducto = true;

  @override
  void initState(){
    super.initState();
    print("Lista de la compra");
    for(Product producto in ListaAComprar.instancia.getProductos()){
      print("Producto: ${producto.getTitle()}, ${producto.getCantidad()}");
    }
  }

  mostarBotonComprar(bool comprar){
    _anyProducto = comprar;
  }

  Widget buildBody() {
    if (ListaAComprar.instancia.getProductos().length <= 0){
      mostarBotonComprar(true);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 176),
        child: Center(
          child: Column(
            children: [
              Opacity(
                opacity: 0.1,
                child: Image.asset("assets/carrito-de-compras.png")),
            ],
          ),
        ),
      );
    }else{
      mostarBotonComprar(false);
      return ListView.builder(
      itemCount: ListaAComprar.instancia.getProductos().length,
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            height: 100,
            child: Card(
              color: Color.fromARGB(255, 132, 212, 250), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Title: ${ListaAComprar.instancia.getProductos()[index].getTitle()}"),
                  trailing: Text("${ListaAComprar.instancia.getProductos()[index].getCantidad()}",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                  ),
                                ),
                  leading: Image.network("${ListaAComprar.instancia.getProductos()[index].getImage()}"),
                ),
              ),
            ),
          ),
        );
      },
    );
    }
  }

  comprarPrductos(){
    //UService.UtilsService.productosComprados
    setState(() {
      ProductosPagados.instancia.setProductos(ListaAComprar.instancia.cloneProducts());
      ListaAComprar.instancia.clearProducts();
      print("Lista de productos pagados: ");
      for(Product producto in ProductosPagados.instancia.getProductos()){
        print("${producto.getTitle()}, ${producto.getCantidad()}");
      }
    });
    
  }

  Widget anyButton(){
    return Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: () {
                        comprarPrductos();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(  
                            borderRadius: BorderRadius.circular(15),
                          )),
                      backgroundColor: MaterialStateProperty.all<Color>(MyColors.AZULMUYOSCURO),
                    ), 
                    child: Icon(Icons.payment,
                      color: MyColors.BLANCOAMARILLESCO,),
                  ),
                ),
              ],
            ),
          ),
        );
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.BLANCOAMARILLESCO,
        child: buildBody()
      ),
      floatingActionButton: _anyProducto ?  SizedBox.shrink() : anyButton(),
      
    );
  }

   
}