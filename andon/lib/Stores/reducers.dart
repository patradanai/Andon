import 'package:andon/Stores/action.dart';
import 'package:andon/Models/categoryModel.dart';
import 'package:andon/Stores/appState.dart';

InitialState categoryReducer(InitialState state, action) {
  switch (action.type) {
    case "CategoryAPI":
      state.category = action.message;
      return state;
    case "STATUSCHANGE":
      state.status = action.message;
      return state;
    default:
      return state;
  }
}
