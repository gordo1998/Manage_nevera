import 'package:flutter/material.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart' as UService;

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
  }

  Widget buildBody() {
    if (UService.UtilsService.productosAComprobar.length <= 0){
      _anyProducto = true;
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
      _anyProducto = false;
      return ListView.builder(
      itemCount: UService.UtilsService.productosAComprobar.length,
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
                  title: Text("Title: ${UService.UtilsService.productosAComprobar[index].getTitle()}"),
                  trailing: Text("${UService.UtilsService.productosAComprobar[index].getCantidad()}",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                  ),
                                ),
                  leading: Image.network("${UService.UtilsService.productosAComprobar[index].getImage()}"),
                ),
              ),
            ),
          ),
        );
      },
    );
    }
  }

  eliminarProducto(){

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
                        eliminarProducto();
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