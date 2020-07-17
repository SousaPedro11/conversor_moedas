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
  double dolar;
  double euro;

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
              return retornoTela('Carregando Dados');
            default:
              if (snapshot.hasError) {
                return retornoTela('Erro ao Carregar Dados');
              } else {
                dolar = getCurrency(snapshot, 'USD');
                euro = getCurrency(snapshot, 'EUR');
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(),
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Reais',
                          labelStyle: TextStyle(
                            color: Colors.amber,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                          prefixStyle: TextStyle(color: Colors.amber),
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      ),
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

//   theme: ThemeData(
//       hintColor: Colors.amber,
//       primaryColor: Colors.white,
//       inputDecorationTheme: InputDecorationTheme(
//         enabledBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
//         hintStyle: TextStyle(color: Colors.amber),
//       )),
// ));
Center retornoTela(String texto) {
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
