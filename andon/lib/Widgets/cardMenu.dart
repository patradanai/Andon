import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CardMenu extends StatelessWidget {
  final Function pressButton;
  final String label;
  final Color color;
  CardMenu({this.pressButton, this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.grey.withAlpha(30),
      splashColor: Colors.black.withAlpha(20),
      onTap: pressButton,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        constraints: BoxConstraints(minHeight: 200),
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
          ],
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
