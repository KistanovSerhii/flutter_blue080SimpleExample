import 'package:flutter/material.dart';

Widget eValueWithTitleInOneLine(
    BuildContext context, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.caption),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Text(
            value,
            style:
                Theme.of(context).textTheme.caption?.apply(color: Colors.black),
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}
