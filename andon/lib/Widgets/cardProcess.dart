import 'package:flutter/material.dart';

class CardProcess extends StatelessWidget {
  final Function pressButton;
  final String operation;
  final String time;
  final String machine;
  final String processing;
  final Color color;

  CardProcess({
    this.pressButton,
    this.operation,
    this.machine,
    this.processing,
    this.time,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.grey.withAlpha(30),
      splashColor: Colors.black.withAlpha(20),
      onTap: pressButton,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
          constraints: BoxConstraints(minHeight: 150),
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 7,
                  offset: Offset(0, 7),
                ),
              ]),
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: Text(
                        operation,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      child: Text(
                        time,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      machine,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      processing,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
