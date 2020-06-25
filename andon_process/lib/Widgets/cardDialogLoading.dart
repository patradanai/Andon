import 'package:flutter/material.dart';

class DialogLoading extends StatelessWidget {
  final String des;
  final bool status;
  final Icon icon;
  DialogLoading({this.des, this.status, this.icon});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contentCard(context, des, status, icon),
      ],
    );
  }
}

Widget contentCard(
    BuildContext context, String description, bool status, Icon icon) {
  return Container(
    constraints: BoxConstraints(minHeight: 300, minWidth: 400),
    padding: EdgeInsets.only(
      top: 50,
      bottom: 16,
      left: 16,
      right: 16,
    ),
    margin: EdgeInsets.only(top: 66, left: 30, right: 30),
    decoration: new BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10.0,
          offset: const Offset(0.0, 10.0),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // To make the card compact
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        status ? CircularProgressIndicator() : icon,
        Material(
          type: MaterialType.transparency,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
      ],
    ),
  );
}
