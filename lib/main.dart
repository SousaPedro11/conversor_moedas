import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      title: 'Conversor de Moedas',
      home: Home(),
    ),
  );
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
