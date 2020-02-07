import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FailMessage extends StatelessWidget {
  final String message;

  const FailMessage({Key key, this.message = 'Ой... Щось пішло не так('})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.display2,
      ),
    );
  }
}
