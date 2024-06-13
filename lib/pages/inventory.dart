import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart' as UService;
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/models/productos_inventario.dart';
import 'package:inventario_home/models/productos_lista_compra.dart';

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
      
      Inventario.instance.getProductos()[index].setSelection(true);
      _isSelected = true;
      print("La variable _isSelected: $_isSelected");
    });
  }

  void deselected(int index){
 
    setState(() {
      print("La variable _isSelected: $_isSelected");
      Inventario.instance.getProductos()[index].setSelection(false);//PONEMOS EL PRODUCTO EN DESSELECCIONADO
      if (Inventario.instance.getProductos().every((producto) => producto.getSelection() == false)){//SI NO HAY NINGUN PRODUCTO SELECCIONADO ENTONCES CAMBIAREMOS _ISSELECTED
        _isSelected = false;
      }
    });
  }

  void deselectedId(String id){
    setState(() {
      print("La variable _isSelected: $_isSelected");
      Product prod = Inventario.instance.getProductos().firstWhere((producto) => producto.getId() == id);
      prod.setSelection(false);
      
      if (Inventario.instance.getProductos().every((producto) => producto.getSelection() == false)){//SI NO HAY NINGUN PRODUCTO SELECCIONADO ENTONCES CAMBIAREMOS _ISSELECTED
        _isSelected = false;
      }
    });
  }

  /*
  //SE LLAMARÁ EN TODO MOMENTO A SELECTDELETE.
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
*/

  //AQUI LE PASAMOS LE CONTENDIO DEL BODY
  //SI LE PRODUCTO ESTÁ SELECCIONADO SE MOSTRARÁ EN EL APPBAR UN ICONO DE ELIMINAR DONDE SE LLAMARÁ A LA FUNCIÓN ELIMINARALLPRODUCTS.
  //DEN EL FLOATINGACTIONBUTTON SE LLAMARÁ A LA FUNCIÓN ISSELECTEDBUTTON DONDE SE LE PASA UN BOOLEANO.
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
      floatingActionButton: selectDelete(_isSelected)     
      
    );
  }
  //Itera todos los productos en la lista. Si el producto está seleccionado y su cantidad es menor a 1 se eliminará de la lista.
  //Si el producto no es menor a 1 se le restará la cantidad de producto.
  eliminarProduct(){
    List<Product> addProduct = [];//ESTA LISTA ES PARA AÑADIRLA A LA LISTA, ES DECIR QUE LA PASAREMOS A LA FUNCION DE ADDLIST
    List<Product> productToremove = [];//ESTA LISTA ES PARA ELIMINARLA

    for(Product product in Inventario.instance.getProductos()){//itero sobre cada producto en la list productos
      
      setState(() {
        if (product.getSelection()){//si el producto está seleccionado
          
          if (product.getCantidad() <= 1){//Si el producto es igual o menor a 1
            Product pCloned = product.cloneAll();//clonamos el producto con todas las cantidades
            addProduct.add(pCloned);//se añade el producto clonado a la lista addProduct //ESTO SE HACE PARA PODER METER ESTE ELEMENTO 
            //EN OTRA LISTA SIN QUE UNA ELIMINACION PUEDA VERSE AFECTADA MÁS ADELANTE
            productToremove.add(product);//se añade el producto para posteriormente ser eliminado con un método.
            deselectedId(product.getId());
            setState(() {});
              
          }
          else{
            addProduct.add(product);
            setState(() {
              product.restCantidad();//si el producto es mayor a 0 simplemente restaremos la cantidad del producto. Como aun hay cantidad no se eliminará. 
            });                      //La cantidad agotada se gestionará más adelante
          }
          
        }

      });

    }
    addProductsList(addProduct);

      
    
   //Si no hay ningún producto seleccionado se cambia la varible para que no aparezca boton
      setState(() {
        if(Inventario.instance.getProductos().every((producto) => producto.getSelection() == false)){
          print("La variable _isSelected: $_isSelected");
          _isSelected = false;
          print("_isSelected cambiado: $_isSelected");
        }
        
      });
    
    Inventario.instance.getProductos().removeWhere((element) => productToremove.contains(element));
    //UService.UtilsService.productos.removeWhere((element) => productToremove.contains(element));//Eliminamos los productos que se han terminado
    setState(() {
      
    });
    
    
    
  }

  //SI SE PRESIONA EL BOTÓN SE AÑADIRÁN TODOS LOS PRODUCTOS DE LA LISTA PRODUCTOS A LISTCOMPRA. 
  //EN CONSECUENCIA, SE ELIMINARÁN TODOS LOS ELEMENTOS DE LA LISTA PRODUCTOS PARA QUE NO SE MUESTREN MÁS ADELANTE.
  Widget eliminarAllProducts(){
    return GestureDetector(
      onTap: (){
        List<Product> listCompra = Inventario.instance.getProductos().where((p) => p.getSelection() == true).toList();
        addAllProductsList(listCompra);
        Inventario.instance.getProductos().removeWhere((p) => p.getSelection() == true);
        //UService.UtilsService.productos.removeWhere((p) => p.getSelection() == true);
        setState(() {_isSelected = false;}); 
      },
      child: Icon(Icons.delete),
    );
  }

  //AÑADE UNA LISTA DE PRODUCTO A LA LISTA DE COMPRAR.
  //LA DIFERENCIA CON ADDALLPRODUCTLIST ES QUE AL AÑADIR POR PRIMERA VEZ UN PRODUCTO A LA LISTA DE COMPRAR SE AÑADIRÁ CON CANTIDAD 1 POR DEFECTO.
  //SI EL PRODUCTO YA ESTÁ EN LA LISTA DE COMPRAR SE LE SUMARÁ A LA CANTIDAD 1.
  addProductsList(List<Product> productos){
    for(Product p in productos){//P SON CADA UNO DE LOS PRODUCTOS PARA SER AÑADIDOS A LA LISTA DE LA COMPRA.
      late Product prod;
      late Product clonedProduct;
      try {
        prod = ListaAComprar.instancia.getProductos().firstWhere((product) => product.getId() == p.getId());//DEVUELVE UN EL PRODUCTO CON LAS MISMAS CARACTERÍSTICAS
        
        setState(() {
            prod.setCantidad(prod.getCantidad() + 1);
        });
      }catch(e){
        if(e is StateError){//ESTE FALLO DARÁ SI NO EXISTE EL PRODUCTO ANTERIO, LO CUAL OBLIGA A GENERARLO
          clonedProduct = p.clone();//CLONAMOS EL PRODUCTO
          setState(() {
            ListaAComprar.instancia.getProductos().add(clonedProduct);
          });
        }else{
          rethrow;
        }
      }
    }
  }
  
  //AÑADE TODOS LOS PRODUCTOS DE LA LISTA PRODUCTOS A LA LISTA PRODUCTOS A COMPRAR
  addAllProductsList(List<Product> productos){
    for(Product p in productos){
      late Product prod;
      try{//Si hay objeto se guarda
        prod = ListaAComprar.instancia.getProductos().firstWhere((product) => product.getId() == p.getId());
       
        setState(() {
          prod.setCantidad(p.getCantidad() + prod.getCantidad());
        });
      } catch (e){//Si hay objeto
        if(e is StateError){
          setState(() {
            ListaAComprar.instancia.getProductos().add(p);
          });
        }else{//Si es una excepcion distinta
          rethrow;
        }
        
      }
    }
  }
  //SI SELECTEDPRODUCT ES VERDADERO MOSTRARÁ UN BOTÓN CENTRADO Y ALINEADO EN EL INFERIOR DE LA PANTALLA. EN CASO CONTRARIO NO MOSTRARÁ NADA.
  //SI SE PRESIONA EL BOTÓN SE LLAMARÁ A LA FUNCIÓN ELIMINARPRODUCT.
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
                      setState(() {
                        eliminarProduct();
                      });
                        
                    },
                    style: ButtonStyle(
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(  
                            borderRadius: BorderRadius.circular(15),
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
    }
  }

  

  Widget circularProgress(){
    return Center(child: CircularProgressIndicator());
  }

  

  Widget contentProduct(){
    List<Product> products = Inventario.instance.getProductos().where((p) => p.getCantidad() > 0).toList();//UService.UtilsService.productos.where((p) => p.getCantidad() > 0).toList();
    
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
                  color: products[index].getSelection() ? Colors.red : MyColors.amarilo//EL PRODUCTO ESTÁ SELECCIONADO SE PONDRÁ EN ROJO, EN CASO CONTRARIO AMARILLO
                )
              ),
              color: products[index].getSelection() ? MyColors.ROJITO : MyColors.amarilo,//Necesito que esto se convierta en una lista
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap:() => deselected(index),//AQUI SE DESELECCIONA
                  onLongPress: () => seleccionado(index),//AQUI SE SELECCIONA EL PRODUCTO DE LA LISTA
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