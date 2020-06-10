import 'package:andon/Stores/action.dart';
import 'package:andon/Models/categoryModel.dart';

AppState categoryReducer(AppState state, action) {
  switch (action.type) {
    case ActionType.CategoryAPI:
      return AppState(category: [...action.message],status: state.status,process: state.process);
      break;
    case ActionType.StatusChanged:
      return AppState(category: state.category,status: action.message,process: state.process);
      break;
    case ActionType.EventAPI:
      return AppState(category: state.category,status: state.status,process: [...action.message]);
      break;
    default:
      return state;
      break;
  }
}
