import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class InventoryAR{
  late RetryClient _client;

  InventoryAR(){
    setClient();
  }

  setClient(){
    _client = RetryClient(http.Client());
  }

  getClient(){
    return _client;
  }

  
}