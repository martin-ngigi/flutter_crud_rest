//stful
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_rest/services/students_services.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  Map? student;
  AddTodoPage({Key? key, this.student}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final student  =widget.student;
    if(student != null){
      isEdit = true;

      //get data
      final name = student['name'];
      final age = student['age'] as int;

      //set data
      titleController.text = name;
      ageController.text = '$age';


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit? "Edit Student": 'Add Student', // if isEdit=true set title as "Edit student, else set title as "Add student"
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
                // if isEdit=true updateData(), else submitData()
                isEdit ? updateData() : submitData();
              },
              child: Text(
                isEdit? "Update": 'Submit', // if isEdit=true set button as Update", else set button as "Submit"

              )
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

    final successBody = await StudentService.addStudent(body);
    //print("successBody-----$successBody");
    if(successBody['code']== 201){
      //   //clear UI
      titleController.clear();
      descriptionController.clear();
      ageController.clear();

      final result = successBody['data'] as Map;

      showSuccessMessage(context, message: 'Creation of ${result['name']} Success');
      print("---------CREATION SUCCESS... BODY : ${result['name']}");
    }
    else{
      showErrorMessage(context, message: "Error occurred while creating.");
      print("----->ERROR: Data creation failed");
    }

  }

  Future<void> updateData() async {

    final student = widget.student;
    if (student == null){
      print("You can not call update without todo data");
      showErrorMessage(context, message: "You can not call update without todo data");
      return;
    }

    int id = student['id'] as int;
    //get data from form
    final name  = titleController.text;
    final description  = descriptionController.text;
    final age  = ageController.text;

    final body = {
      "name": name,
      "age": age,
    };
    final isSuccess = await StudentService.updateData(id, body);

    if (isSuccess){
      showSuccessMessage(context, message: "$name Updated successfully.");
    }
    else{
      showErrorMessage(context, message: "Failed to update $name");
    }
  }

}
