import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/login.dart';
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

  //Controllers
  final TextEditingController _usernameController = new TextEditingController();
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
          usernameInput(),

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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, must authenticate
//
                                User u = await postLoginUser();
                                print("User = name: ${u.name} lastname: ${u.lastName} email: ${u.email} grr: ${u.grr} password: ${u.password}");
                                Navigator.popAndPushNamed(context, '/main');
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

  Future<User> postLoginUser() async {
    AccountCredentials l = new AccountCredentials(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    String loginJson = json.encode(l.toJson());
    print(loginJson);
    print("Post em $_url/login");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      //HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };
    User success = await http
        .post("$_url/login", body: loginJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Post Login Success!");
        var j = json.decode(response.body);
        globals.token = j["token"];
        globals.userName = _usernameController.text;

        User u = new User(
            name: "Sucessso",
            lastName: "Sucesso",
            password: _passwordController.text,
            email: "sucesso@mail.com",
            grr: _usernameController.text);
        return u;

      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });
    return success;
  }

  Padding usernameInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _usernameController,
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


