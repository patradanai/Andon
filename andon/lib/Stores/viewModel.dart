import 'package:andon/Models/categoryModel.dart';
import 'package:redux/redux.dart';
import 'package:andon/Stores/action.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ModelView {
  final List<CategoryModel> category;
  final List<EventProcess> event;
  final Function() getCategory;
  final Function() getEventProcess;
  final String status;
  final Store store;
  ModelView(
      {this.category,
      this.event,
      this.getCategory,
      this.getEventProcess,
      this.status,
      this.store});

  factory ModelView.create(Store<AppState> store) {
    _getCategory() {
      store.dispatch(getCategoryAction());
    }

    _getEventProcess() {
      store.dispatch(getEventAction());
    }

    return ModelView(
        category: store.state.category,
        event: store.state.process,
        getCategory: _getCategory,
        getEventProcess: _getEventProcess,
        status: store.state.status,
        store: store );
  }
}
