import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userGrrController =
    new TextEditingController();
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

  List _days = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
  List _months = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho",
    "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"];
  List _years = [];

  List<DropdownMenuItem<String>> _dropDownMenuItemsDays;
  List<DropdownMenuItem<String>> _dropDownMenuItemsMonths;
  List<DropdownMenuItem<String>> _dropDownMenuItemsYears;

  String _currentDay;
  String _currentMonth;
  String _currentYear;
  //1900 - 2100
  var now = new DateTime.now();
  var formatter = new DateFormat.y();

  @override
  void initState() {

    String year = formatter.format(now);
    print("Year: $year");
    int y = int.parse(year);
    loadYears();

    _dropDownMenuItemsDays = getDropDownMenuItems(1);
    _currentDay = _dropDownMenuItemsDays[0].value;

    _dropDownMenuItemsMonths = getDropDownMenuItems(2);
    _currentMonth = _dropDownMenuItemsMonths[0].value;

    _dropDownMenuItemsYears = getDropDownMenuItems(3);
    _currentYear = _dropDownMenuItemsYears[y-1900].value;
    super.initState();
  }


  void loadYears() {
    int y;
    for (int i = 0; i < 200; i++) {
      y = i + 1900;
      _years.add(y);
    }
  }
  void changedDropDownItemDay(String selected) {
    setState(() {
      _currentDay = selected;
    });
  }
  void changedDropDownItemMonth(String selected) {
    setState(() {
      _currentMonth = selected;
    });
  }
  void changedDropDownItemYear(String selected) {
    setState(() {
      _currentYear = selected;
    });
  }
  //I usado para indicar se é para DIA - MES - ANO
  List<DropdownMenuItem<String>> getDropDownMenuItems(int i) {
    List<DropdownMenuItem<String>> items = new List();
      if(i == 1){
        for (int day in _days) {
          items.add(new DropdownMenuItem(value: "$day", child: new Text("$day")));
        }
        return items;
      }
      else if (i == 2) {
        for (String month in _months) {
          items.add(new DropdownMenuItem(value: month, child: new Text(month)));
        }
        return items;
      }
      else if (i == 3){
        for (int year in _years) {
          items.add(new DropdownMenuItem(value: "$year", child: new Text("$year")));
          print(year);
        }
        return items;
      }
    return null;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
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
                    icon: Icon(Icons.navigate_next, color: Colors.white,)),
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
                      icon: Icon(Icons.navigate_next, color: Colors.white,),
                    )),
              ),

              //Data de Nascimento:
              Padding(
                  padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.5),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        )),
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
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Dia
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: new DropdownButton(
                                value: _currentDay,
                                items: _dropDownMenuItemsDays,
                                onChanged: changedDropDownItemDay,
                              ),
                            ),
                            //Mês
                            Text("/"),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: new DropdownButton(
                                value: _currentMonth,
                                items: _dropDownMenuItemsMonths,
                                onChanged: changedDropDownItemMonth,
                              ),
                            ),
                            //Ano
                            Text("/"),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: new DropdownButton(
                                value: _currentYear,
                                items: _dropDownMenuItemsYears,
                                onChanged: changedDropDownItemYear,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),

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
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  controller: _userPassConfirmController,
                  decoration: InputDecoration(
                      hintText: "Confirme sua senha: ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.5)),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: Colors.black)
                    ),
                    icon: Icon(Icons.navigate_next, color: Colors.white,)),
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
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
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
                                    // If the form is valid...
                                  }
                                  //Verifica data
                                  //Verifica email
                                  //Verifica as senhas
                                  //Gera Post.
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
            ],
          ),
        ),
      ),
    );
  }
}
