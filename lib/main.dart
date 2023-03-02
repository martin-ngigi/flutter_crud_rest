import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: 'Flutter REST CRUD consuming',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: Home(),
    );
  }
}
