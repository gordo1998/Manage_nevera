import 'dart:convert';

import 'package:http/retry.dart';
import 'package:inventario_home/models/product.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:http/http.dart' as http;

class Service{
  late RetryClient _connection;

  Service(){
    setConnection();
  }

  setConnection(){
    _connection = RetryClient(http.Client());
  }

  RetryClient getConnection(){
    return _connection;
  }

  closeConnection(){
    _connection.close();
  }

  Future<Product> requesteProduct(String barCode) async {
    late Product product;
    late final response;

    try{
      response = await getConnection().get(Uri.parse("${UtilsService.URL}$barCode.json"));
      Map<String, dynamic> decodeResponse = jsonDecode(response.body);
      
      if (response.statusCode == 504){
        throw Exception("Tiempo de espera agotado!");
      }
      else{
        if(decodeResponse["status"] == 0){
          throw Exception("No hay registros del Producto");
        }else if(decodeResponse["status"] == 1){
          Map<String, dynamic> respuesta = decodeResponse["product"];
          product = Product(respuesta["generic_name_es"], 
                        respuesta["image_front_small_url"], 
                        respuesta["_id"]);
        }
        
      }
    } on Exception catch(e) {
      print("Ha ocurrido un error: $e");
      
    }

    return product;
  }
}