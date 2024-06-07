import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/pages/camera_site.dart';
import 'package:inventario_home/pages/home_page.dart';
import 'package:inventario_home/pages/inventory.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/pages/scanner.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.home: (context) => HomePage(),
    Routes.camera: (context) => CameraSite(title: "Camera"),
    Routes.scanner: (context) => Scanner(title: "Scanner"),
    Routes.inventory: (context) => Inventory(title: "Inventory"),
  };
}

List<Widget> get getPages{
  return [
    Scanner(title: "Scanner"),
    HomePage(), 
    Inventory(title: "Inventory")
  ]; 
}