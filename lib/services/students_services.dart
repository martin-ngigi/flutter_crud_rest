import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';

//all student api call will be here
class StudentService{

  static Future<Map> addStudent(Map body) async {

    //submit the data to the server.
    final url = '${Constants.BASE_URL}/create';
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {"accept":"application/json", "Content-Type":"application/json"}
    );

    final json = jsonDecode(response.body) as Map;
    //print(json['code']);
    //return json['code'] == 201; //true or false
    return json;

  }

  static Future<bool> deleteById(int id) async {
    //delete item
    final url = '${Constants.BASE_URL}/delete/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(
        uri,
        headers: {"accept":"application/json"}
    );
    final json = jsonDecode(response.body) as Map;
    print(json['code']);

    return json['code'] == 200; //true or false
  }

  static Future<List> fetchTodo() async {
    final url = Constants.BASE_URL+"/all";
    final uri = Uri.parse(url);
    final response = await http.get(
        uri,
        headers: {"accept":"application/json"}
    );
    final json = jsonDecode(response.body) as Map;
    //print(json['code']);

    if(json['code'] == 200) {
      final result = json['data'] as List;
      return result;
    }
    else{
      //else return an empty list
      return [];
    }

  }

  static Future<bool> updateData(int id, Map body) async {

    //submit the data to the server.
    final url = '${Constants.BASE_URL}/update/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {"accept":"application/json", "Content-Type":"application/json"}
    );

    final json = jsonDecode(response.body) as Map;
    //print(json['code']);
    return json['code'] == 200; //true or false

  }
}