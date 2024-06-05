import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:inventario_home/utils/utils_service.dart' as UService;



class CameraSite extends StatefulWidget {
  const CameraSite({super.key, required this.title});
  final String title;

  @override
  State<CameraSite> createState() => _CameraSite();
}

class _CameraSite extends State<CameraSite> {
  UService.WidgetState _widgetState = UService.WidgetState.NONE; //Este será el estado de la camara antes de iniciarse la camara
  List<CameraDescription>? _cameras; //Aquí se guardarán todas las cámaras que contiene el dispositivo
  CameraController? _cameraController; //Esta será la camara que nosostros querremos usar

  @override
  void initState(){
    super.initState();
    iniciarCamara();//Esta función inicia la cámara nada más empezar la aplicación
  }

  Future<void> iniciarCamara() async{
    _widgetState = UService.WidgetState.LOADING;//Cambiamos el estado
    if(mounted) {//Si el widget principal está montado entonces iniciamos la cámara
      setState(() {});
    }

    _cameras = await availableCameras();// Nos devuelve todas las cámaras disponibles
    _cameraController = CameraController(_cameras![0], ResolutionPreset.high);//Aqui indicamos la camara que queremos
    //ahora iniciamos esa cámara una vez sabemos cual queremos
    await _cameraController!.initialize();

    //Si la cámara devuelve un error lo sabremos, en caso contrario diremos que ya se ha cargado
    if(_cameraController!.value.hasError){
      _widgetState = UService.WidgetState.ERROR;
      if(mounted){
        setState((){});
      }
    }else{
      _widgetState = UService.WidgetState.LOADED;
      if(mounted){
        setState((){});
      }
    }


  }

  Widget buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Camera"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          XFile xfile = await _cameraController!.takePicture();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  Widget build(BuildContext context) {

    switch(_widgetState){
      case UService.WidgetState.NONE:
      case UService.WidgetState.LOADING:
        return buildScaffold(context, Center(child: CircularProgressIndicator()));
      case UService.WidgetState.LOADED:
        return buildScaffold(context, CameraPreview(_cameraController!));
      case UService.WidgetState.ERROR:
        return buildScaffold(context, Center(child: Text("Parece que ha habido un error"),));
    }
  }
}