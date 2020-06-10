import 'package:flutter/material.dart';

class CardProcess extends StatelessWidget {
  final Function pressButton;
  final String operation;
  final Color color;

  CardProcess({
    this.pressButton,
    this.operation,
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
                offset: Offset(0, 2),
              ),
            ]),
        child: Container(
          padding: EdgeInsets.all(30),
          width: double.infinity,
          child: Center(
            child: Text(
              operation,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
