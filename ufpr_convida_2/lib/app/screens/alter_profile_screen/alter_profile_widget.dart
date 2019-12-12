import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/login.dart';
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class AlterProfileWidget extends StatefulWidget {
  User user;

  AlterProfileWidget({Key key, @required this.user}) : super(key: key);

  @override
  _AlterProfileWidgetState createState() => _AlterProfileWidgetState(user);
}

class _AlterProfileWidgetState extends State<AlterProfileWidget> {
  User user;

  _AlterProfileWidgetState(this.user);

  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();
  bool created = false;

  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
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
  final TextEditingController _userOldPasswordController =
      new TextEditingController();
  final TextEditingController _userPasswordController =
      new TextEditingController();
  final TextEditingController _userPassConfirmController =
      new TextEditingController();

  bool isSwitchedPassword = false;

  @override
  void initState() {
    _userGrrController.text = user.grr;
    _userFirstNameController.text = user.name;
    _userLastNameController.text = user.lastName;
    _userEmailController.text = user.email;

    DateTime parsedBirth;

    if (user.birth != null) {
      parsedBirth = DateTime.parse(user.birth);
      selectedDateUser = parsedBirth;
      dateUser = postFormat.format(parsedBirth);
      showDateUser = formatter.format(parsedBirth);
    }

    super.initState();
  }

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
                  "Perfil",
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
                        this.selectedDateUser = DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day);
                        dateUser = postFormat.format(selectedDateUser);
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
                          child: new Text(
                            "Data de Nascimento: ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Dia
                              Text(
                                "$showDateUser",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            //User email:
            userEmail(),

            //Switch
            Padding(
              padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
              child: Row(
                children: <Widget>[
                  Text("Deseja alterar sua senha?",
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                  Switch(
                      value: isSwitchedPassword,
                      onChanged: (value) {
                        setState(() {
                          print("Executou um setState");
                          isSwitchedPassword = value;
                        });
                      }),
                ],
              ),
            ),

            Container(
              child: isSwitchedPassword == true
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          userOldPassword(),
                          userPassword("Nova senha:"),
                          userConfirmPassword("Confirme nova senha:"),
                        ],
                      ),
                    )
                  : userPassword("Senha:"),
            ),
            //User password

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
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/main");
                        },
                        padding: EdgeInsets.fromLTRB(45, 12, 45, 12),
                        child: Text('Cancelar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
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
                          int ok = 0;
                          if (created) {
                            Navigator.of(context).pushNamed("/main");
                          }

                          if ((_formKey.currentState.validate()) &&
                              (created == false)) {

                            bool correct = await passCheck();

                            if (correct) {
                              String success = await putUser();
                              String desc = "Pressione 'Ok' para continar";
                              _showDialog(success, desc, true);
                              created = true;
                            } else {
                              String error = "Alguma senha não está correta";
                              String desc = "Pressione 'Ok' e tente novamente";
                              _showDialog(error, desc, false);
                            }
                          }
                        },
                        padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                        child: Text('Alterar',
                            //Color(0xFF295492),(0xFF8A275D)
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Padding userOldPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userOldPasswordController,
        decoration: InputDecoration(
            hintText: "Senha Antiga: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Favor entre com sua Antiga';
          }
          return null;
        },
        obscureText: true,
      ),
    );
  }

  void _showDialog(String s, String desc, bool ok) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(s),
          content: new Text(desc),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                if (ok) {
                  Navigator.pop(context);
                  Navigator.of(context).popAndPushNamed("/login");
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> passCheck() async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    AccountCredentials ac = new AccountCredentials(
        password: _userPasswordController.text, username: user.grr);
    String acJson = jsonEncode(ac);
    print(acJson);

    bool correct = await http
        .put("$_url/users/checkpass", body: acJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("-------------------------------------------------------");
      print("Request on: $_url/users/checkpass");
      print("Status Code: ${response.statusCode}");
      print("Checking User Password...");
      print("-------------------------------------------------------");

      if ((statusCode == 200) || (statusCode == 201)) {
        return true;
      } else {
        return false;
      }
    });

    return correct;
  }

  Future<String> putUser() async {
    User u = new User(
        grr: user.grr,
        name: _userFirstNameController.text,
        lastName: _userLastNameController.text,
        password: _userPasswordController.text,
        email: _userEmailController.text,
        birth: dateUser);

    String userJson = json.encode(u.toJson());
    print(userJson);
    print("Put em $_url/users/${user.grr}");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    String s = await http
        .put("$_url/users/${user.grr}", body: userJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("-------------------------------------------------------");
      print("Request on: $_url/users/${user.grr}");
      print("Status Code: ${response.statusCode}");
      print("Putting User Alteration...");
      print("-------------------------------------------------------");

      if (statusCode == 204) {
        return "Usuário Alterado com sucesso!";
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });
    return s;
  }

  Padding userConfirmPassword(String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userPassConfirmController,
        decoration: InputDecoration(
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
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

  Padding userPassword(String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userPasswordController,
        decoration: InputDecoration(
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.email)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Favor entre com seu E-mail';
          }
          if (!(value.contains("@"))) {
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
        enabled: false,
        controller: _userGrrController,
        decoration: InputDecoration(
          hintText: "Seu GRR:",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
          //),
          icon: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
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
      lastDate: DateTime(2100));
}
