

import 'dart:core';

import 'package:inventario_home/models/product.dart';

class Inventario{
  List<Product> _productos = [];

  //Constructor privado para evitar que se creen instancias fuera de la clase
  Inventario._internal();

  // Única instancia de la clase
  static final Inventario _instance = Inventario._internal();

  // Método para obtener la instancia única de la clase
  static Inventario get instance => _instance;

  List<Product> getProductos(){
    return _productos;
  }

  setProductos(List<Product> productos){
    _productos = productos;
  }

}