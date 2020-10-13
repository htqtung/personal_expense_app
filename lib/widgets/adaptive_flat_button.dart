import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  AdaptiveFlatButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    )
        : FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}
