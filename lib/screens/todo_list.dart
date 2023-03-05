





//stful
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/constants/constants.dart';
import 'package:flutter_crud_rest/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
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
          'REST CRUD (Pull down to refresh)',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.grey,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: (){
            return fetchTodo();
          },
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index){
                final item  = items[index] as Map;
                final id  = item['id'] as int;
                return ListTile(
                  leading: CircleAvatar(child: Text("${index+1}"),),
                  title: Text(item['name']),
                  subtitle: Text(item['age'].toString()),
                  trailing: PopupMenuButton(
                    itemBuilder: (context){
                      return [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: "edit",
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "delete",
                        ),
                      ];
                    },
                    onSelected: (value){
                      if(value == 'edit' ){
                        //navigate to edit page
                        navigateToEditPage(item);
                      }
                      else if (value == 'delete'){
                        //delete and remove the item
                        deleteById(id);
                      }
                    },
                  ),
                );
              }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){navigateToAddPage();},
        label: Text("Add Todo"),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context ) => AddTodoPage(student: item),
    );
    await Navigator.push(context, route);
    //refresh page after adding
    setState(() {
      isLoading =true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context ) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    //refresh page after adding
    setState(() {
      isLoading =true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final url = Constants.BASE_URL+"/all";
    final uri = Uri.parse(url);
    final response = await http.get(
        uri,
        headers: {"accept":"application/json"}
    );
    final json = jsonDecode(response.body) as Map;
    //print(json['code']);

    if(json['code'] == 200){
      final result = json['data'] as List;

      setState(() {
        items = result;
      });

      print("----->SUCCESS RESPONSE, ALL TODOS: ${result}");

    }
    else{
      print("-----> ERROR OCCURRED WHILE FETCHING ALL TODOS");

    }

    setState(() {
      isLoading = false;
    });

  }

  Future<void> deleteById(int id) async {
    //delete item
    final url = '${Constants.BASE_URL}/delete/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(
        uri,
        headers: {"accept":"application/json"}
    );
    final json = jsonDecode(response.body) as Map;
    print(json['code']);

    if(json['code'] == 200){
      //show all items apart from item which id is not egual to deletef item
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
      });

      showSuccessMessage("SUCCESS RESPONSE, STUDENT DELETED");
      print("----->SUCCESS RESPONSE, STUDENT DELETED");

    }
    else{
      showErrorMessage("ERROR OCCURRED WHILE DELETING STUDENT");
      print("-----> ERROR OCCURRED WHILE DELETING STUDENT");

    }
    //remove the item from list
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
