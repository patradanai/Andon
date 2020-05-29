import 'package:andon/Stores/action.dart';
import 'package:andon/Models/categoryModel.dart';

AppState categoryReducer(AppState state, action) {
  switch (action.type) {
    case ActionType.CategoryAPI:
      return AppState(category: []..add(action.message));
    case ActionType.StatusChanged:
      return AppState(status: action.message);
    default:
      return state;
  }
}
