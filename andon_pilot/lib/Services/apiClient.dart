import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Constants.dart' as con;

class ApiClient {
  static Future<List<CategoryModel>> fetchAlbum() async {
    final response = await http.get(con.baseUrl + '/api/category/');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var list = json.decode(response.body);
      List<CategoryModel> payload = [];
      for (var i in list) {
        CategoryModel category = CategoryModel.fromJson(i);
        payload.add(category);
      }
      return payload;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  static Future<List<EventProcess>> fetchProcess() async {
    final response = await http.get(con.baseUrl + "/api/process/");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var list = json.decode(response.body);
      List<EventProcess> payload = [];
      for (var i in list) {
        EventProcess eventProcess = EventProcess.fromJson(i);
        if (eventProcess.process != 'Done') {
          payload.add(eventProcess);
        }
      }
      return payload;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
