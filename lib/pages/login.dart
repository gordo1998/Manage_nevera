import 'package:flutter/material.dart';
import 'package:inventario_home/routes/routes.dart';
import 'package:inventario_home/service_AR/usersAR.dart';
import 'package:inventario_home/utils/colors.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login>{

  final formKey = GlobalKey<FormState>();
  final controladorEmail = TextEditingController();
  final controladorPassword = TextEditingController();
  UsersAR serviceUser = UsersAR();
  int stateRegister = -1;

  @override
  void initState(){
    super.initState();
  }
  
  Widget textErrorLogin(int stateRegister){
    switch (stateRegister) {
      case 1:
        return Text("email o contraseña incorrecto!", style: TextStyle(color: Colors.red),);
      default:
        return SizedBox.shrink();
    }
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
              Icon(Icons.lock, color: MyColors.AZULCLARITO,),
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
              Icon(Icons.email, color: MyColors.AZULCLARITO,),
              SizedBox(width: 5,),
              Text("Email", style: TextStyle(color: Color.fromARGB(100, 0, 0, 0),),)
            ],
          ),
          fillColor: MyColors.BLANCOAMARILLESCO,
          filled: true,
          border: OutlineInputBorder()
        ),
        validator: (value){
          if(value!.isEmpty){
            return "You should put any email!";
          }
        }
      ),
    );
  }

  Widget haveAccount(){
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(context, Routes.register);
      },
      child: Text("No tengo cuenta de Freeze.", 
          style: TextStyle(color: MyColors.AZULCLARITO, fontWeight: FontWeight.bold),),
    );
  }
  
  Widget botonLogin() {
    return Container(
      width: 130,
      height: 50,
      child: ElevatedButton(
        onPressed: () async{
          if(formKey.currentState!.validate()){
            Map<String, dynamic> respuestaRegistro =  await serviceUser.loginUser({"email" : controladorEmail.text, "password" : controladorPassword.text});
            setState(() {
              if (respuestaRegistro["respuesta"] == true){
                Navigator.pushReplacementNamed(context, Routes.home);
                
              
              } else if(respuestaRegistro["respuesta"] == false){
                stateRegister = 1;
              } else{
                print(respuestaRegistro["respuesta"].toString());
              }
            });
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(MyColors.AZULCLARITO),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(color: MyColors.BLANCOAMARILLESCO),),
            SizedBox(width: 5),
            Icon(Icons.login, color: MyColors.BLANCOAMARILLESCO,),
          ],
        ),
      ),
    );
  }
  Widget titleRegister(){
    return Text(
      "Login", 
      style: TextStyle(
        fontSize: 40, 
        color: MyColors.AZULCLARITO,
        fontFamily: "FrescoStamp",
      ),
    );
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
              textErrorLogin(stateRegister),
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
        color: MyColors.AZULMUYOSCURO,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            titleRegister(),
            formRegister(),
            botonLogin(),
            
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: haveAccount()),
      ),
    ); 
  }
}