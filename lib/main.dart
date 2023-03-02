import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/screens/todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter REST CRUD consuming',
      theme: ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}
