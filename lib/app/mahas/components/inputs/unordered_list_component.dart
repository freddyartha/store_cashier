import 'package:flutter/material.dart';

class UnorderedListComponent extends StatelessWidget {
  const UnorderedListComponent(this.texts, this.style, {super.key});
  final List<String> texts;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      widgetList.add(UnorderedListItem(text, style));
      widgetList.add(const SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, this.style, {super.key});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '• ',
          style: style,
        ),
        Expanded(
          child: Text(
            text,
            style: style,
          ),
        ),
      ],
    );
  }
}
