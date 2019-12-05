import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;


class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

  //Controllers
  final TextEditingController _loginController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final String msg = 'criar um evento!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text("Configurações")),
        body: Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Image.asset(
            //Image:
            "assets/logo-ufprconvida-sembordas.png",
            width: 200.0,
            height: 200.0,
            //color: Colors.white70,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(52, 12, 30, 12),
            child: Container(
              alignment: Alignment.center,
              child: Text("É necessário logar para $msg",
                  style: TextStyle(
                    color: Color(0xFF295492),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          //Login
          loginInput(),

          //Password
          passwordInput(),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Botao Entrar
                Container(
                    margin: const EdgeInsets.all(4.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF295492),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, go to first page
                                Navigator.pushNamed(context,'/main');
                              }
                            },
                            padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                            child: Text('Entrar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF8A275D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              //When press Signup:
                              Navigator.of(context).pushNamed("/signup");
                            },
                            padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                            child: Text('Cadastrar',
                                //Color(0xFF295492),(0xFF8A275D)
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Padding loginInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _loginController,
        decoration: InputDecoration(
            hintText: "Email ou GRR: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),

            icon: Icon(Icons.person)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Entre com seu login';
          }
          return null;
        },
      ),
    );
  }

  Padding passwordInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
            hintText: "Senha: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Entre com sua senha';
          }
          return null;
        },
        obscureText: true,
      ),
    );
  }
}
