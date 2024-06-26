import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/service_AR/productosEscaneadosAR.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/personal_widgets.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:inventario_home/models/productos_inventario.dart';

class Scanner extends StatefulWidget{
  const Scanner({super.key, required this.title});
  final String title;

  @override
  State<Scanner> createState() => _Scanner();
}

class _Scanner extends State<Scanner>{

  late Product _product;
  ProductosEscaneadosAR pEscaneado = ProductosEscaneadosAR();
  Service service = Service();
  String? _barcodeResult;
  var barcodeScanRes;

  Future<void> getProduct(String code) async{
    Map<String, String> producto = {"codigo_barras" : code};
    Map<String, dynamic> scanProduct = await pEscaneado.existProduct(producto);
    if (scanProduct["exist"] == true){
      //Ira a la base de datos
    }else if (scanProduct["exist"] == false){
      _product = await service.requesteProduct(code);
      anyadirCantidadProductos(_product.getId().toString());
      setState((){});
    }
    
  }
  

  void anyadirCantidadProductos(String idProducto){
    
    if(Inventario.instance.getProductos().any((product) => product.getId().contains(idProducto))){
      Product product = Inventario.instance.getProductos().firstWhere((p) => p.getId() == idProducto);//DEVUELVE EL PRODUCTO ENCONTRADO
      product.addCantidad();//Aumentamos una cantidad
    }else {
      _product.setCantidad(1);
      Inventario.instance.getProductos().add(_product);
      //UtilsService.productos.add(_product);

    }
  }
  
  void scannerNormal() async{
    
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", 
      "cancel", 
      true, 
      ScanMode.BARCODE
      );
      await getProduct(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = "Failed to get  platform version";
    }

    setState(() {
      _barcodeResult = barcodeScanRes;
      //Navigator.pushNamed(context, Routes.inventory, arguments: _barcodeResult);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.BLANCOAMARILLESCO,
      ),
      body: Container(
        color: MyColors.BLANCOAMARILLESCO,
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: AlignmentDirectional.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset("assets/codigodebarragrande.png")),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Container(
                    width: 90,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () async{
                        scannerNormal();
                      }, 
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(  
                          borderRadius: BorderRadius.circular(15),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(MyColors.AZULMUYOSCURO),
                      ),
                      child: Icon(Icons.barcode_reader, color: MyColors.BLANCOAMARILLESCO,),
                    ),
            )
              ],
            )
          
          ],
        ),
      ),
      
    );
  }

  
}

