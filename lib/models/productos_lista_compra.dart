import 'dart:core';

import 'package:inventario_home/models/product.dart';

class ListaAComprar{
  List<Product> _productos = [];

  ListaAComprar._lista();
  static final _instancia = ListaAComprar._lista();
  static ListaAComprar get instancia => _instancia;

  List<Product> getProductos(){
    return _productos;
  }

  setProductos(List<Product> productos){
    _productos = productos;
  }

  List<Product> cloneProducts(){
    return _productos.map((producto) => producto.cloneAll()).toList();
  }

  clearProducts(){
    _productos.clear();
  }

}