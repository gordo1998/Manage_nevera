
import 'dart:collection';
import 'package:inventario_home/models/product.dart';


class UtilsService{
  static const String URL = "https://world.openfoodfacts.org/api/v2/product/";
  static const String API_KEY = "hdpcxijpfv61k65b6v43mnnd8ksvg0";
  static List<Product> productos = [];
  static Map<String, int> cantidadPorProducto = new HashMap();// No es la forma más optima pero asi lo he hecho 
  static int selectIndex = 1;
}

enum WidgetState{NONE, LOADING, LOADED, ERROR}


