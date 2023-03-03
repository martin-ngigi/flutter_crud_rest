//stful
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Todo',
          style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.grey,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          TextField(
            controller: ageController,
            decoration: InputDecoration(
              hintText: 'Age',),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: (){
                submitData();
              },
              child: Text('Submit')
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //get data from form
    final name  = titleController.text;
    final description  = descriptionController.text;
    final age  = ageController.text;

    final body = {
      "name": name,
      "age": age,
    };

    //submit the data to the server.
    //final url = 'http://api.nstack.in/v1/todos';
    final url = '${Constants.BASE_URL}/create';
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {"accept":"application/json", "Content-Type":"application/json"}
    );

    try{
      // //show success or fail message based on status
      // if(response.statusCode == 201){
      //   //clear UI
      //   titleController.clear();
      //   descriptionController.clear();
      //   ageController.clear();
      //
      //   print("----->SUCCESS RESPONSE: ${response.body}");
      //   showSuccessMessage('Creation of $title Success');
      // }
      // else{
      //   showErrorMessage("Error occurred while creating.");
      //   print("----->ERROR: Data creation failed");
      // }
      final json = jsonDecode(response.body) as Map;
      print(json['code']);

      if(json['code'] == 201){
        //   //clear UI
          titleController.clear();
          descriptionController.clear();
          ageController.clear();

        final result = json['data'] as Map;

        showSuccessMessage('Creation of $name Success');
        print("----->SUCCESS RESPONSE, ADDED STUDENT: ${result}");

      }
      else{
        showErrorMessage("Error occurred while creating.");
        print("----->ERROR: Data creation failed");

      }
    }
    catch(e){
      print("-----> ERROR OCCURRED: ${e}");
      showErrorMessage("Error occurred while creating.\n i.e. $e");

    }
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
