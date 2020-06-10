import 'package:flutter/material.dart';

class DialogContent extends StatelessWidget {
  final String title;
  final String des;
  final Function accept;
  final Function cancel;
  DialogContent({this.title, this.des, this.accept, this.cancel});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        contentCard(context, title, des, accept, cancel),
        // Positioned(
        //   left: 16,
        //   right: 16,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.blueAccent,
        //     radius: 66,
        //   ),
        // ),
      ],
    );
  }
}

Widget contentCard(BuildContext context, String title, String description,
    Function accept, Function cancel) {
  return Container(
    constraints: BoxConstraints(minHeight: 300),
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
        Material(
          type: MaterialType.transparency,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Material(
          type: MaterialType.transparency,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                shape: StadiumBorder(),
                onPressed: cancel,
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF801E8F),
                  ),
                ),
              ),
              FlatButton(
                shape: StadiumBorder(),
                onPressed: accept,
                child: Text(
                  "Accept",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF801E8F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
