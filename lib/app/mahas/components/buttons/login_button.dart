import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../mahas_colors.dart';
import '../mahas_themes.dart';
import '../texts/text_component.dart';

enum LoginButtonType { google, apple }

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final LoginButtonType type;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final title = type == LoginButtonType.google
        ? "Lanjutkan menggunakan Google"
        : "Lanjutkan menggunakan Apple";
    final icon = type == LoginButtonType.google
        ? FontAwesomeIcons.google
        : FontAwesomeIcons.apple;
    final backgroundColor =
        type == LoginButtonType.google ? MahasColors.red : MahasColors.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MahasThemes.borderRadius / 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const Padding(padding: EdgeInsets.all(5)),
          TextComponent(
            value: title,
            fontWeight: FontWeight.w500,
            fontColor: MahasColors.light,
          ),
        ],
      ),
    );
  }
}
