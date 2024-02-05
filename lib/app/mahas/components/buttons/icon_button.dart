// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../mahas_themes.dart';

@Deprecated(
    "Do not use this component anymore. Please use ButtonComponent instead.")
class ButtonWithIcon extends StatefulWidget {
  final String label;
  final Icon? icon;
  final Color? color;
  final double? radius;
  final Function()? onTap;

  const ButtonWithIcon({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.color,
    this.radius,
  });

  @override
  State<ButtonWithIcon> createState() => _ButtonWithIconState();
}

// ignore: deprecated_member_use_from_same_package
class _ButtonWithIconState extends State<ButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(widget.radius ?? MahasThemes.borderRadius)),
        ),
      ),
      onPressed: widget.onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon ?? const Icon(FontAwesomeIcons.envelope),
          const Padding(padding: EdgeInsets.all(5)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
