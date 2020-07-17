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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\$ Conversor de Moedas \$'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(),
    );
  }
}
