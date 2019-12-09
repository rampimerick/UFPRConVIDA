import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();


  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  String showDateUser = "";
  String dateUser;

  DateTime selectedDateUser = DateTime.now();
  //Controllers:
  final TextEditingController _userGrrController = new TextEditingController();
  final TextEditingController _userFirstNameController =
      new TextEditingController();
  final TextEditingController _userLastNameController =
      new TextEditingController();
  final TextEditingController _userEmailController =
      new TextEditingController();
  final TextEditingController _userPasswordController =
      new TextEditingController();
  final TextEditingController _userPassConfirmController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            //Text:
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
            //User first name:
            userFirstName(),

            //User last name
            userLastName(),

            //User GRR:
            userGrr(),
            //User Birthday
            Padding(
                padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      )),
                  child: InkWell(
                    onTap: () async {
                      final selectedDate = await _selectedDate(context);
                      if (selectedDate == null) return 0;

                      setState(() {
                        this.selectedDateUser = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day
                        );
                        dateUser = dateFormat.format(selectedDateUser);
                        showDateUser = formatter.format(selectedDateUser);
                        print("Formato data post: $dateUser");
                      });
                      return 0;
                    },
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                          child: new Text("Data de Nascimento: ", style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Dia
                              Text("$showDateUser", style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54
                              ),),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            //User email:
            userEmail(),

            //User password
            userPassword(),

            //Confirm password:
            userConfirmPassword(),

            //Buttons:
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
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () => Navigator.of(context).pushNamed('/main'),
                        padding: EdgeInsets.fromLTRB(45, 12, 45, 12),
                        child: Text('Cancelar',
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if(_userPassConfirmController.text.compareTo(_userPasswordController.text) == 0){
                              User u = await postNewUser();
                            }
                          }
                        },
                        padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                        child: Text('Confirmar',
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
    );
  }
  
  Future<User> postNewUser() async {
    User u = new User(
        name: _userFirstNameController.text,
        lastName: _userLastNameController.text,
        grr: _userGrrController.text,
        email: _userEmailController.text,
        password: _userPasswordController.text
    );

    String userJson = json.encode(u.toJson());
    print(userJson);
    print("Post em $_url/user");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      //HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    User success = await http
        .post("$_url/user", body: userJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Post User Success!");
        return User.fromJson(json.decode(response.body));
      } else {
        throw new Exception("Error while fetching data, status code: $statusCode");
      }
    });

    return success;
  }

  Padding userConfirmPassword() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _userPassConfirmController,
              decoration: InputDecoration(
                  hintText: "Confirme sua senha: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  icon: Icon(Icons.lock)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com sua Senha';
                }
                return null;
              },
              obscureText: true,
            ),
          );
  }

  Padding userPassword() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _userPasswordController,
              decoration: InputDecoration(
                  hintText: "Senha: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  icon: Icon(Icons.lock)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com sua Senha';
                }
                return null;
              },
              obscureText: true,
            ),
          );
  }

  Padding userEmail() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _userEmailController,
              decoration: InputDecoration(
                  hintText: "Email: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  icon: Icon(Icons.email)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com seu E-mail';
                }
                if (!(value.contains("@"))){
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
          );
  }

  Padding userGrr() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: _userGrrController,
                decoration: InputDecoration(
                  hintText: "Seu GRR:",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  //),
                  icon: Icon(Icons.navigate_next, color: Colors.white,),
                ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com seu GRR';
                }
                if (!value.contains('GRR')){
                  return 'GRR inválido';
                }
                return null;
              },
            ),
          );
  }

  Padding userLastName() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _userLastNameController,
              decoration: InputDecoration(
                  hintText: "Sobrenome: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com seu Sobrenome';
                }
                return null;
              },
            ),
          );
  }

  Padding userFirstName() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _userFirstNameController,
              decoration: InputDecoration(
                  hintText: "Nome: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5)),
                  icon: Icon(Icons.person)),
              //Validations:
              validator: (value) {
                if (value.isEmpty) {
                  return 'Favor entre com seu Nome';
                }
                return null;
              },
            ),
          );
  }



  Future<DateTime> _selectedDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100)
  );
}
