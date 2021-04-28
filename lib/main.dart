/**
 * Program utama dari aplikas
 */
import 'package:flutter/material.dart';
import 'Retrieve.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blog Rest API'),
    );
  }
}
