import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;

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
            Padding(
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
            ),

            //User last name
            Padding(
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
            ),

            //User GRR:
            Padding(
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
            ),
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
            Padding(
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
            ),

            //User password
            Padding(
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
            ),

            //Confirm password:
            Padding(
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
            ),

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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if(_userPassConfirmController.text.compareTo(_userPasswordController.text) == 0){

                            }
                            // If the form is valid...
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

  Future<DateTime> _selectedDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}
