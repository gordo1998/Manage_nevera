import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class UsersAR {
  late RetryClient _client;

  UsersAR(){
    setUserAR();
  }

  setUserAR(){
    _client = RetryClient(http.Client());
  }

  RetryClient getUsetAR(){
    return _client;
  }

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> usuario) async{
    
    try{
      final response = await getUsetAR().post(
            Uri.parse("http://192.168.1.62:8080/register"),
            headers: {"Content-Type" : "application/json"},
            body: jsonEncode(usuario)
            );
      
      print(response.statusCode.toString());

      if(response.statusCode != 200){
        return {"respuesta" : "Algo ha fallado con el servidor"};
      }else if(response.statusCode == 200){
        Map<String, dynamic> responseUser = jsonDecode(response.body);
        if(responseUser["existUser"]){
          return {"respuesta" : true};
        }else{
          return {"respuesta" : false};
        }
      }
    } on Exception catch (e){
      return {"respuesta" : "Ha ocurrido un error inesperado: $e"};
    } 
    return {"respuesta" : "Error desconocido"};
  }

  Future<Map<String, dynamic>> loginUser(Map<String, dynamic> usuario) async{
    
    try{
      final response = await getUsetAR().post(
            Uri.parse("http://192.168.1.62:8080/login"),
            headers: {"Content-Type" : "application/json"},
            body: jsonEncode(usuario)
            );
      
      print(response.statusCode.toString());

      if(response.statusCode != 200){
        return {"respuesta" : "Algo ha fallado con el servidor"};
      }else if(response.statusCode == 200){
        Map<String, dynamic> responseUser = jsonDecode(response.body);
        if(responseUser["existUser"]){
          return {"respuesta" : true};
        }else{
          return {"respuesta" : false};
        }
      }
    } on Exception catch (e){
      return {"respuesta" : "Ha ocurrido un error inesperado: $e"};
    } 
    return {"respuesta" : "Error desconocido"};
  }



}