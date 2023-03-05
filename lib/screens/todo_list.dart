





//stful
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/constants/constants.dart';
import 'package:flutter_crud_rest/screens/add_page.dart';
import 'package:flutter_crud_rest/services/students_services.dart';
import 'package:http/http.dart' as http;

import '../utils/snackbar_helper.dart';

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

  Widget _buildCard(int index, Map item, int id){
    /**
     * If we were to pass functions
     */
    //final Function(Map) navigateEdit;
    //final Function(int) deleteById;

    return Card(
      child: ListTile(
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
      ),
    );
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
          child: Visibility(
            visible: items.isNotEmpty,
              replacement: Center(
                child: Text(
                    "No students in list",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index){
                  final item  = items[index] as Map;
                  final id  = item['id'] as int;
                  return _buildCard(index, item, id);
                }
            ),
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

    final response  =  await StudentService.fetchTodo();

    if(response != null){
      setState(() {
        items = response;
      });

      print("----->SUCCESS RESPONSE, ALL STUDENTS: ${response}");

    }
    else{
      print("-----> ERROR OCCURRED WHILE FETCHING ALL STUDENTS");
      showErrorMessage(context, message: "ERROR OCCURRED WHILE FETCHING ALL STUDENTS");
    }

    setState(() {
      isLoading = false;
    });

  }

  Future<void> deleteById(int id) async {
    //delete item
    final isSuccess = await StudentService.deleteById(id);
    if(isSuccess){
      //show all items apart from item which id is not egual to deletef item
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
      });

      showSuccessMessage(context, message: "SUCCESS RESPONSE, STUDENT DELETED");
      print("----->SUCCESS RESPONSE, STUDENT DELETED");

    }
    else{
      showErrorMessage(context, message:  "ERROR OCCURRED WHILE DELETING STUDENT",);
      print("-----> ERROR OCCURRED WHILE DELETING STUDENT");

    }
  }

}
