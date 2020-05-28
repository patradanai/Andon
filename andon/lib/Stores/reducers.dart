import 'package:andon/Stores/action.dart';
import 'package:andon/Models/categoryModel.dart';

categoryReducer(state, dynamic action) {
  if (action == "UPDATECATEGORY") {
    state.counter++;
    return state;
  }
  return state;
}
