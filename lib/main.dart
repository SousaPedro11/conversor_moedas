import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _request_key = '07194033';
const _request_base = 'https://api.hgbrasil.com/finance';
const _request_api = '$_request_base/?format=json&key=$_request_key';

void main(List<String> args) async {
  runApp(
    MaterialApp(
      title: 'Conversor de Moedas',
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    ),
  );
}

Future<Map> getData() async {
  var response = await http.get(_request_api);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    realController.text = (euro * this.euro).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Conversor de Moedas \$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return buildSnapshotMessage('Carregando Dados');
            default:
              if (snapshot.hasError) {
                return buildSnapshotMessage('Erro ao Carregar Dados');
              } else {
                dolar = getCurrency(snapshot, 'USD');
                euro = getCurrency(snapshot, 'EUR');
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          'Reais', 'R\$ ', realController, _realChanged),
                      Divider(),
                      buildTextField(
                          'Dolares', 'U\$ ', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          'Euros', '€ ', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  getCurrency(AsyncSnapshot<Map> snapshot, String currency) =>
      snapshot.data['results']['currencies'][currency]['buy'];
}

Center buildSnapshotMessage(String texto) {
  return Center(
    child: Text(
      texto,
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function c) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: c,
  );
}
