import 'package:andon/Stores/action.dart';

class StateModel {
  CategoryAction state;
  Function onUpdateState;

  StateModel({this.state, this.onUpdateState});
}
