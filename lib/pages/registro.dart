import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario_home/pages/home_page.dart';
import 'package:inventario_home/utils/colors.dart';
import 'package:inventario_home/utils/utils_service.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/routes/app_routes.dart';


class Registro extends StatefulWidget{
  const Registro({super.key});
  
  @override
  State<Registro> createState() => _Registro();
}

class _Registro extends State<Registro>{

  final formKey = GlobalKey<FormState>();
  List<TextEditingController> controladores = [];
  final controladorEmail = TextEditingController();
  final controladorUser = TextEditingController();
  final controladorPassword = TextEditingController();

  @override
  void initState(){
    super.initState();
  }
  

  Widget textPasswordConfirm(){
    return Container(
      height: 40,
      child: TextFormField(
        controller: controladorUser,
        autofocus: false,
        obscureText: true,
        style: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.5,
              color: MyColors.AZULMUYOSCURO
            )
          ),
          label: Row(
            children: [
              Icon(Icons.lock, color: MyColors.AZULMUYOSCURO,),
              SizedBox(width: 5,),
              Text("Confirm Password", style: TextStyle(color: Color.fromARGB(100, 0, 0, 0),),)
            ],
          ),
          fillColor: MyColors.BLANCOAMARILLESCO,
          filled: true,
          border: OutlineInputBorder()
        ),
        validator: (value){
          if(value!.isEmpty){
            return "You should put any password!";
          }
        }
      ),
    );
  }

  Widget textPassword(){
    return Container(
      height: 40,
      child: TextFormField(
        controller: controladorPassword,
        autofocus: false,
        obscureText: true,
        style: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.5,
              color: MyColors.AZULMUYOSCURO
            )
          ),
          label: Row(
            children: [
              Icon(Icons.lock, color: MyColors.AZULMUYOSCURO,),
              SizedBox(width: 5,),
              Text("Password", style: TextStyle(color: Color.fromARGB(100, 0, 0, 0),),)
            ],
          ),
          fillColor: MyColors.BLANCOAMARILLESCO,
          filled: true,
          border: OutlineInputBorder()
        ),
        validator: (value){
          if(value!.isEmpty){
            return "You should put any password!";
          }
        }
      ),
    );
  }

  

  Widget textEmail(){
    return Container(
      height: 40,
      child: TextFormField(
        controller: controladorEmail,
        autofocus: false,
        obscureText: false,
        style: TextStyle(
          color: Color.fromARGB(200, 0, 0, 0),
        ),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.5,
              color: MyColors.AZULMUYOSCURO
            )
          ),
          label: Row(
            children: [
              Icon(Icons.email, color: MyColors.AZULMUYOSCURO,),
              SizedBox(width: 5,),
              Text("Email", style: TextStyle(color: Color.fromARGB(100, 0, 0, 0),),)
            ],
          ),
          fillColor: MyColors.BLANCOAMARILLESCO,
          filled: true,
          border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget haveAccount(){
    return SizedBox.shrink();
  }
  
  Widget botonRegister() {
    return Container(
      width: 130,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.home);
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Register"),
            SizedBox(width: 5),
            Icon(Icons.login),
          ],
        ),
      ),
    );
  }
  Widget titleRegister(){
    return Text("Register");
  }

  //ESTE CONTENEDOR CONTIENE EL FORMULARIO DE REGISTRO
  Widget formRegister(){
    return Form(
      key: formKey,
      child: Container(
        width: 250,
        child: Center(
          child: Column(
            children: [
              textEmail(),
              SizedBox(height: 13,),
              textPassword(),
              SizedBox(height: 13,),
              textPasswordConfirm(),
            ],
          ),
        ),
      ),
    );
  }

  
  //ESTE MÉTODO DEVUELVE UN CONTENEDOR QUE CONTIENE EL FORMULARIO
  Widget boxForm(){
    return Container(
      width: 270,
      height: 500,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(100, 0, 0, 0),
            spreadRadius: 5,
            blurRadius: 5

          )
        ],
        color: MyColors.AZULOSCURO,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            titleRegister(),
            formRegister(),
            botonRegister(),
            
          ],
        ),
      ),
    );
  }
  //ESTO ES TODO EL BODY, ES DECIR, TODA LA PANTALLA
  Widget buildBody(){
    return Container(
      color: MyColors.BLANCOAMARILLESCO,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            boxForm(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: buildBody(),
      floatingActionButton: haveAccount(),
    );
  }
}



