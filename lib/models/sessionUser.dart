
class SessionUser{
  late bool _sesionIniciada;

  SessionUser._sessionUser();
  static final _session = SessionUser._sessionUser();
  static SessionUser get instancia => _session;

  initSession(){
    _sesionIniciada = true;
  }
  
  exitSession(){
    _sesionIniciada = false;
  }


}