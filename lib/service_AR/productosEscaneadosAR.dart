import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';  

class ProductosEscaneadosAR{
  late RetryClient _client;

  ProductosEscaneadosAR(){
    setClient();
  }

  setClient(){
    _client = RetryClient(http.Client());
  }

  RetryClient getClient(){
    return _client;
  }

  Future<Map<String, dynamic>> existProduct(Map<String, String> producto) async{
    try{
      final response = await getClient().post(
        Uri.parse("http://192.168.1.62:8080/existProduct"),
        headers: {"Content-Type" : "application/json"},
        body:jsonEncode(producto)
      );

      print(response.statusCode);
      if(response.statusCode == 200){
        Map<String, dynamic> prod = jsonDecode(response.body);
        if(prod["exist"] == true){
          return {"exist" : true};
        }else if(prod["exist"] == false){
          return {"exist" : false};
        }else{
          return {"respuesta" : "${prod["message"]}"};
        }
      }else{
          return {"respuesta" : "Error con el servidor"};
      }

    }on Exception catch (e){
      return {"respuesta" : "Ha ocurrido un error inesperado: $e"};
    }
  }
}