import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../mahas_colors.dart';
import '../mahas_themes.dart';
import '../texts/text_component.dart';

class InputBoxComponent extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final double? marginBottom;
  final String? childText;
  final Color? childTextColor;
  final Widget? children;
  final Widget? childrenSizeBox;
  final GestureTapCallback? onTap;
  final bool alowClear;
  final String? errorMessage;
  final IconData? icon;
  final bool? isRequired;
  final bool editable;
  final double? borderRadius;
  final Color? boxColor;
  final Function()? clearOnTab;

  const InputBoxComponent({
    super.key,
    this.label,
    this.labelStyle,
    this.marginBottom,
    this.childText,
    this.childTextColor = MahasColors.dark,
    this.onTap,
    this.children,
    this.childrenSizeBox,
    this.alowClear = false,
    this.clearOnTab,
    this.errorMessage,
    this.isRequired = false,
    this.icon,
    this.borderRadius,
    this.editable = false,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: label != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                TextComponent(
                  value: label ?? '-',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                Visibility(
                  visible: isRequired == true,
                  child: TextComponent(
                    value: "*",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontColor: MahasColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: children == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        borderRadius ?? MahasThemes.borderRadius),
                    color: boxColor ??
                        MahasColors.dark.withOpacity(editable ? .01 : .05),
                    border: errorMessage != null
                        ? Border.all(color: MahasColors.danger.withOpacity(.5))
                        : Border.all(
                            color: MahasColors.dark
                                .withOpacity(editable ? .1 : .3)),
                  ),
                  padding: childrenSizeBox != null
                      ? null
                      : const EdgeInsets.only(left: 10, right: 10),
                  child: childrenSizeBox ??
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onTap,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  childText ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: childTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: alowClear,
                            child: SizedBox(
                              width: 20,
                              height: 30,
                              child: InkWell(
                                onTap: clearOnTab,
                                child: const Icon(
                                  FontAwesomeIcons.xmark,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !alowClear && icon != null,
                            child: SizedBox(
                              width: 20,
                              height: 30,
                              child: InkWell(
                                onTap: onTap,
                                child: Icon(
                                  icon,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              ),
              Visibility(
                visible: errorMessage != null,
                child: TextComponent(
                    value: errorMessage ?? "",
                    fontSize: 10,
                    fontColor: MahasColors.danger,
                    padding: const EdgeInsets.only(left: 12)),
              ),
            ],
          ),
        ),
        Visibility(
          visible: children != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              children ?? Container(),
              Visibility(
                visible: errorMessage != null,
                child: TextComponent(
                    value: errorMessage ?? "",
                    fontSize: 10,
                    fontColor: MahasColors.danger,
                    padding: const EdgeInsets.only(left: 12)),
              ),
            ],
          ),
        ),
        SizedBox(height: marginBottom ?? 0),
      ],
    );
  }
}
