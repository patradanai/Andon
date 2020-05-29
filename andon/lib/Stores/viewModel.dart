import 'package:andon/Models/categoryModel.dart';
import 'package:redux/redux.dart';
import 'package:andon/Stores/action.dart';
class CategoryView {
  final List<CategoryModel> state;
  final Function() getCategory;
  final String status;
  CategoryView({this.state, this.getCategory,this.status});

  factory CategoryView.create(Store<AppState> store){
    _getCategory() {
      store.dispatch(getEvent());
    }
    return CategoryView(
      state: store.state.category,
      getCategory: _getCategory,
      status: store.state.status
    );
  }
}
