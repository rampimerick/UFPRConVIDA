import 'package:flutter/material.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  //Variáveis da Tela, controladores para saber quais são os imputs do usuário
  final TextEditingController _usuarioController = new TextEditingController();
  final TextEditingController _senhaController = new TextEditingController();

  int selectedRadio;
  @override
  void initState(){
    super.initState();
    selectedRadio = 0;
  }

  void SelectedRadio(int val){
      setState(() {
        selectedRadio = val;
      });
  }

  //Método que puxa a tela principal quando tudo esta ok com o Login
  Future _abrirTela(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new telaPrincipal();
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //Barra superior
//      appBar: AppBar(
//        title: Text("UFPR ConVIDA"),
//        backgroundColor: Colors.blueAccent,
//        centerTitle: true,
//      ),

      //Corpo do aplicativo que ficará alternando
      body: Container(
        alignment: Alignment.topCenter,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Image.asset(
              //Imagem LOGO da UFPR
              "assets/logo-ufprconvida-sembordas.png",

              width: 200.0,
              height: 200.0,
              //Possível mudança de cor
              //color: Colors.white70,
            ),
            Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //Campos de entrada de dados
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Professor"),
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (val){
                            print("Radio: $val");
                            SelectedRadio(val);
                          },
                          //activeColor: Colors.indigo,
                        ),
                        Text("Aluno"),
                        Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (val){
                            print("Radio: $val");
                            SelectedRadio(val);
                          },
                          //activeColor: Colors.indigo,
                        ),
                      ],
                    ),
                    //GRR --> Ex. GRR2018XXXX
                    Container(
                      child: Row(
                        children: <Widget>[],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _usuarioController,
                        decoration: InputDecoration(
                            hintText: "GRR: ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.5)),
                            icon: Icon(Icons.person)),
                      ),
                    ),
                    //Senha ******
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _senhaController,
                        decoration: InputDecoration(
                            hintText: "Senha: ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.5)),
                            icon: Icon(Icons.lock)),
                        //Para ocultar a senha:
                        obscureText: true,
                      ),
                    ),

                    Center(
                      //Linha para os botões
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //Botao Entrar
                          Container(
                            margin: const EdgeInsets.all(4.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: FlatButton(
                                    onPressed: _logar,
                                    color: Color(0xFF295492),
                                    child: Text(
                                      "Entrar",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  child: FlatButton(
                                    onPressed: _logar,
                                    color: Color(0xFF8A275D),
                                    child: Text(
                                      "Cadastrar",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17.0),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  //Método que será chamado quando o usuario clicar no botao ENTRAR
  void _logar() {
    if (_usuarioController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty) {
      //Chama outra página depois de tratar adquadamente
      // a entrada de dados!
      _abrirTela(context);
    }
    //Caso não informado alguns dos campos:
    //Mostrará um Alerta informando ao usuario o que deve ser feito.
    else {
      var alert = AlertDialog(
        title: Text(
          "Campo vazio!",
          style: TextStyle(color: Colors.redAccent, fontSize: 18.0),
        ),
        content: Text("Favor digitar seu GRR e Senha"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  //Limpa os campos
                  _senhaController.clear();
                  _usuarioController.clear();
                });
                Navigator.pop(context);
              },
              child: Text("OK!")),
        ],
      );
      showDialog(context: context, builder: (context) => alert);
    }
  }
}
