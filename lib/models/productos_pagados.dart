import 'package:inventario_home/models/product.dart';

class ProductosPagados{
  List<Product> _productos = [];

  ProductosPagados._productos();
  static final _instance = ProductosPagados._productos();
  static ProductosPagados get instancia => _instance;

  List<Product> getProductos(){
    return _productos;
  }

  setProductos(List<Product> productos){
    _productos = productos;
  }
}