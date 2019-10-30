import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _userGrrController = new TextEditingController();
  final TextEditingController _userFirstNameController = new TextEditingController();
  final TextEditingController _userLastNameController = new TextEditingController();
  final TextEditingController _userEmailController = new TextEditingController();
  final TextEditingController _userPasswordController = new TextEditingController();
  final TextEditingController _userPassConfirmController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            //Texto Inicial
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Cadastro",
                  style: TextStyle(
                      color: Color(0xFF295492), //Color(0xFF8A275D),
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //GRR
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _userGrrController,
                  decoration: InputDecoration(
                    hintText: "Seu GRR:",
                    border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.5)),
                    //),
                    icon: Icon(Icons.assignment_ind),
                  )),
            ),

            //Nome
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userFirstNameController,
                decoration: InputDecoration(
                    hintText: "Nome: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.person)),
              ),
            ),

            //Sobrenome
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userLastNameController,
                decoration: InputDecoration(
                    hintText: "Sobrenome: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.person)),
              ),
            ),

            //Email
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userEmailController,
                decoration: InputDecoration(
                    hintText: "Email: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.email)),
              ),
            ),

            //Senha
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userPasswordController,
                decoration: InputDecoration(
                    hintText: "Senha: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.lock)),
                //Para ocultar a senha:
                obscureText: true,
              ),
            ),

            //Confirmação de Senha
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _userPassConfirmController,
                decoration: InputDecoration(
                    hintText: "Confirme sua senha: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.lock)),
                //Para ocultar a senha:
                obscureText: true,
              ),
            ),

            //Botões
            Center(
              //Linha para os botões
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  //Botao Cancelar
                  Container(
                      margin: const EdgeInsets.all(4.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Color(0xFF295492),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(24),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              padding:
                              EdgeInsets.fromLTRB(45, 12, 45, 12),
                              child: Text('Cancelar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Color(0xFF8A275D),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                //AO CONFIRMAR
                              },
                              padding:
                              EdgeInsets.fromLTRB(43, 12, 43, 12),
                              child: Text('Confirmar',
                                  //Color(0xFF295492),(0xFF8A275D)
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18)),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
