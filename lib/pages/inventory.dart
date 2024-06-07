import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/utils/colors.dart';
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

  Widget isSelectButton(select){
    switch (select) {
      case true:
        return selectDelete(true);
      case false:
        return selectDelete(false);
      default:
        return selectDelete(false);
    }
  }


  Widget buildScaffold(BuildContext context, Widget body){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.BLANCOAMARILLESCO,
        actions: <Widget>[
          _isSelected ? eliminarAllProducts() : Icon(Icons.abc_sharp),
        ],
      ),
      body: Container(
              color: MyColors.BLANCOAMARILLESCO,
              child: body
            ),
      floatingActionButton: isSelectButton(_isSelected)     
      
    );
  }
  //Itera todos los productos en la lista. Si el producto está seleccionado y su cantidad es menor a 1 se eliminará de la lista.
  //Si el producto no es menor a 1 se le restará la cantidad de producto.
  eliminarProduct(){
    List<Product> addProduct = [];
    List<Product> productToremove = [];
    for(Product product in UService.UtilsService.productos){
      
      
      if (product.getSelection()){//si el producto está seleccionado
        
        if (product.getCantidad() <= 0){//Si el producto es menor a 1
          Product pCloned = product.cloneAll();
          addProduct.add(pCloned);
          productToremove.add(product);
          //UService.UtilsService.productos.remove(product);
             
        }
        else{
          setState(() {
            product.restCantidad();
          });
        }
        addProduct.add(product);
      }
      
    }
      
    UService.UtilsService.productos.removeWhere((element) => productToremove.contains(element));//Eliminamos los productos que se han terminado
    if(UService.UtilsService.productos.any((producto) => producto.getSelection() != true)){//Si no hay ningún producto seleccionado se cambia la varible para que no aparezca boton
      setState(() {
        _isSelected = false;
      });
    }
    
    
    addProductsList(addProduct);
  }

  Widget eliminarAllProducts(){
    return GestureDetector(
      onTap: (){
        List<Product> listCompra = UService.UtilsService.productos.where((p) => p.getSelection() == true).toList();
        addAllProductsList(listCompra);
        UService.UtilsService.productos.removeWhere((p) => p.getSelection() == true);
        setState(() {_isSelected = false;}); 
      },
      child: Icon(Icons.delete),
    );
  }

  addProductsList(List<Product> productos){
    for(Product p in productos){
      late Product prod;
      late Product clonedProduct;
      try {
        prod = UService.UtilsService.productosAComprobar.firstWhere((product) => product.getId() == p.getId());
        
        setState(() {
            prod.setCantidad(prod.getCantidad() + 1);
        });
      }catch(e){
        if(e is StateError){
          clonedProduct = p.clone();
          setState(() {
            UService.UtilsService.productosAComprobar.add(clonedProduct);
          });
        }else{
          rethrow;
        }
      }
    }
  }

  addAllProductsList(List<Product> productos){
    for(Product p in productos){
      late Product prod;
      try{//Si hay objeto se guarda
        prod = UService.UtilsService.productosAComprobar.firstWhere((product) => product.getId() == p.getId());
       
        setState(() {
          prod.setCantidad(p.getCantidad() + prod.getCantidad());
        });
      } catch (e){//Si hay objeto
        if(e is StateError){
          setState(() {
            UService.UtilsService.productosAComprobar.add(p);
          });
        }else{//Si es una excepcion distinta
          rethrow;
        }
        
      }
    }
  }

  Widget selectDelete(bool selectedProduct){
    
    switch (selectedProduct){
      case true:
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
                        eliminarProduct();
                    },
                    style: ButtonStyle(
                      shape: _isSelected ? MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(  
                            borderRadius: BorderRadius.circular(15),
                          )) : MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(  
                            borderRadius: BorderRadius.circular(0),
                          )),
                      backgroundColor: MaterialStateProperty.all<Color>(MyColors.AZULMUYOSCURO),
                    ), 
                    child: Icon(Icons.delete,
                      color: MyColors.BLANCOAMARILLESCO,),
                  ),
                ),
              ],
            ),
          ),
        );
      case false:
        return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }

  

  Widget circularProgress(){
    return Center(child: CircularProgressIndicator());
  }

  

  Widget contentProduct(){
    List<Product> products = UService.UtilsService.productos.where((p) => p.getCantidad() > 0).toList();
    if (products.length <= 0){
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Column(
            children: [
              Opacity(
                opacity: 0.1,
                child: Image.asset("assets/inventario-disponible.png")),
            ],
          ),
        ),
      );
    }else{
      return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index){
        return Center(
          child: Container(
            height: 100,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 2,
                  color: _isSelected ? Colors.red : MyColors.AZULCLARITO
                )
              ),
              color: products[index].getSelection() ? MyColors.ROJITO : MyColors.AZULCLARITO,//Necesito que esto se convierta en una lista
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap:() => deselected(index),
                  onLongPress: () => seleccionado(index),
                  child: ListTile(
                    title: Text("${products[index].getTitle()}"),
                    trailing: Text("${products[index].getCantidad().toString()}",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                  ),
                              ),
                    leading: Image.network(products[index].getImage()),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }
    
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