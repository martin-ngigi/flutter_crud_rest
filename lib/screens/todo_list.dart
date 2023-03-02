//stful
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){navigateToAddPage();},
          label: Text("Add Todo"),
      ),
    );
  }

  void navigateToAddPage(){
    final route = MaterialPageRoute(
        builder: (context ) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }
}
