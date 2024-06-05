import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/service/service.dart';
import 'package:inventario_home/utils/personal_widgets.dart';
import 'package:inventario_home/utils/utils_service.dart';

class Scanner extends StatefulWidget{
  const Scanner({super.key, required this.title});
  final String title;

  @override
  State<Scanner> createState() => _Scanner();
}

class _Scanner extends State<Scanner>{

  late Product _product;
  Service service = Service();
  String? _barcodeResult;
  var barcodeScanRes;

  Future<void> getProduct(String code) async{
    _product = await service.requesteProduct(code);
    anyadirCantidadProductos(_product.getId().toString());
    setState((){});
  }
  

  void anyadirCantidadProductos(String idProducto){
    
    if(UtilsService.productos.any((product) => product.getId().contains(idProducto))){
      Product product = UtilsService.productos.firstWhere((p) => p.getId() == idProducto);//DEVUELVE EL PRODUCTO ENCONTRADO
      product.addCantidad();//Aumentamos una cantidad
    }else {
      _product.setCantidad(1);
      UtilsService.productos.add(_product);

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
        title: Text("Screen"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: AlignmentDirectional.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async{
                scannerNormal();
                }, 
                child: Text("Scanear")),
          ],
        ),
      ),
      
    );
  }

  
}

