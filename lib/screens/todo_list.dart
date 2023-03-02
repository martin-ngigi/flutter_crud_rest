





//stful
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
List items =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

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
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index){
            final item  = items[index] as Map;
            return ListTile(
              leading: CircleAvatar(child: Text("${index+1}"),),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              // trailing: ,
            );
          }
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

  Future<void> fetchTodo() async {
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(
        uri,
        headers: {"accept":"application/json"}
    );
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final result = json['items'] as List;

      setState(() {
        items = result;
      });

      print("----->SUCCESS RESPONSE, ALL TODOS: ${response.body}");

    }
    else{
      print("-----> ERROR OCCURRED WHILE FETCHING ALL TODOS");

    }

  }
}
