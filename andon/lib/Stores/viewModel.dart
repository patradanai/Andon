import 'package:andon/Models/categoryModel.dart';
import 'package:redux/redux.dart';
import 'package:andon/Stores/action.dart';

class CategoryView {
  final List<CategoryModel> category;
  final List<EventProcess> event;
  final Function() getCategory;
  final Function() getEventProcess;
  final String status;
  CategoryView(
      {this.category,
      this.event,
      this.getCategory,
      this.getEventProcess,
      this.status});

  factory CategoryView.create(Store<AppState> store) {
    _getCategory() {
      store.dispatch(getCategoryAction());
    }

    _getEventProcess() {
      store.dispatch(getEventAction());
    }

    return CategoryView(
        category: store.state.category,
        event: store.state.process,
        getCategory: _getCategory,
        getEventProcess: _getEventProcess,
        status: store.state.status);
  }
}
