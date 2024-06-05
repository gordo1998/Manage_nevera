import 'package:flutter/material.dart';

class ListaCompra extends StatefulWidget {
  const ListaCompra({super.key, required this.title});
  final String title;

  @override
  State<ListaCompra> createState() => _ListaCompra();
}

class _ListaCompra extends State<ListaCompra> {

  @override
  void initState(){
    super.initState();    
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.home),
          ],
        ),
      ),
    );
  }

   
}