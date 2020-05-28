import 'package:andon/Stores/action.dart';
import 'package:andon/Models/categoryModel.dart';

categoryReducer(state, action) {
  switch (action.type) {
    case "CategoryAPI":
      state.category = action.message;
      return state;
    default:
      return state;
  }
}
