import 'package:flutter/material.dart';

class DialogLoading extends StatelessWidget {
  final String des;
  final bool status;
  DialogLoading({this.des, this.status});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contentCard(context, des, status),
      ],
    );
  }
}

Widget contentCard(BuildContext context, String description, bool status) {
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
        status
            ? CircularProgressIndicator()
            : Icon(
                Icons.check_circle_outline,
                color: Colors.greenAccent,
                size: 120,
              ),
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
