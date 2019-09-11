import 'package:flutter/material.dart';

class Evento extends StatelessWidget{
  String _eventoNome;
  String _eventoData;
  String _eventoLocal;

  Evento(this._eventoNome, this._eventoData, this._eventoLocal);

  String get eventoLocal => _eventoLocal;

  set eventoLocal(String value) {
    _eventoLocal = value;
  }

  String get eventoData => _eventoData;

  set eventoData(String value) {
    _eventoData = value;
  }

  String get eventoNome => _eventoNome;

  set eventoNome(String value) {
    _eventoNome = value;
  }

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Container();

  }

}
