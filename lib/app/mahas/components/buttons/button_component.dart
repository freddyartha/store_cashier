import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../texts/text_component.dart';

class ButtonComponent extends StatefulWidget {
  final Function() onTap;
  final String text;
  final Color textColor;
  final Color btnColor;
  final FontWeight fontWeight;
  final double fontSize;
  final double borderRadius;
  final double? width;
  final bool isMultilineText;
  final String? icon;
  final bool isSvg;
  final bool isIconData;
  final IconData? iconData;
  final Color? iconDataColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  const ButtonComponent({
    super.key,
    required this.onTap,
    required this.text,
    required this.btnColor,
    this.textColor = MahasColors.light,
    this.fontWeight = FontWeight.normal,
    this.fontSize = MahasFontSize.normal,
    this.borderColor = Colors.transparent,
    this.width,
    this.isMultilineText = false,
    this.icon,
    this.isSvg = true,
    this.isIconData = false,
    this.iconData,
    this.iconDataColor,
    this.borderRadius = 10,
    this.padding,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? Get.width,
        padding: widget.padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColor),
          color: widget.btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon != null
                ? widget.isSvg
                    ? SvgPicture.asset(
                        widget.icon!,
                        width: 15,
                      )
                    : Image(
                        image: AssetImage(widget.icon!),
                        width: 15,
                      )
                : widget.isIconData
                    ? Icon(
                        widget.iconData,
                        color: widget.iconDataColor,
                        size: 18,
                      )
                    : Container(),
            widget.icon != null || widget.iconData != null
                ? const SizedBox(
                    width: 20,
                  )
                : Container(),
            Flexible(
              flex: widget.isMultilineText ? 1 : 0,
              child: TextComponent(
                value: widget.text,
                fontColor: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                textAlign: TextAlign.center,
                margin: widget.icon != null
                    ? const EdgeInsets.only(left: 10)
                    : EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
