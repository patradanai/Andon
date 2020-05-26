import 'package:flutter/material.dart';

class DialogContent extends StatelessWidget {
  final String title;
  final String des;
  DialogContent({this.title, this.des});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contentCard(context, title, des),
        Positioned(
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 66,
          ),
        ),
      ],
    );
  }
}

Widget contentCard(BuildContext context, String title, String description) {
  return Container(
    constraints: BoxConstraints(minHeight: 400),
    padding: EdgeInsets.only(
      top: 82,
      bottom: 16,
      left: 16,
      right: 16,
    ),
    margin: EdgeInsets.only(top: 66, left: 50, right: 50),
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
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 24.0),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop(); // To close the dialog
            },
            child: Text("Okay"),
          ),
        ),
      ],
    ),
  );
}
