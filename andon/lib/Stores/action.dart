import 'dart:convert';
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Services/apiClient.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:andon/Constants.dart' as con;
import 'package:http/http.dart' as http;

ThunkAction<CategoryModel> getEvent() => (Store store) async {
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

        store.dispatch(
            UpdateAction(type: ActionType.CategoryAPI, message: payload));
      } else {
        throw Exception('Failed to load');
      }
    };

class UpdateAction {
  ActionType type;
  dynamic message;
  UpdateAction({this.type, this.message});
}

enum ActionType {
  CategoryAPI,
  DisconnectSocket,
  ConnectSocket,
  StatusChanged,
}
