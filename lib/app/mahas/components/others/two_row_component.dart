import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../mahas_widget.dart';
import '../texts/text_component.dart';

class TwoRowComponent extends StatelessWidget {
  final String? title;
  final String? data;
  final int? titleMaxLines;
  final int? dataMaxLines;
  final double? colonMargin;
  final double titleWidth;
  final TextAlign titleAlign;
  final TextAlign dataAlign;
  final EdgeInsetsGeometry padding;
  final double titleFontSize;
  final double dataFontSize;
  final bool titleMuted;
  final bool dataMuted;
  final Color titleColor;
  final Color dataColor;
  final FontWeight titleFontWeight;
  final FontWeight dataFontWeight;
  final bool isTitleIcon;
  final IconData? titleIcon;
  final bool isDataIcon;
  final IconData? dataIcon;
  final Alignment titleIconAlign;
  final Alignment dataIconAlign;
  final Function()? titleOnTap;
  final Function()? dataOnTap;
  final bool isCustomDataWidget;
  final Widget? dataCustomWidget;
  final bool isLoading;
  final bool isWithColon;
  final bool isInPixel;
  const TwoRowComponent({
    super.key,
    this.title,
    this.data,
    this.titleMaxLines,
    this.dataMaxLines,
    this.colonMargin,
    this.titleWidth = 0.25,
    this.titleAlign = TextAlign.start,
    this.dataAlign = TextAlign.start,
    this.padding = const EdgeInsets.only(bottom: 3),
    this.titleFontSize = MahasFontSize.normal,
    this.dataFontSize = MahasFontSize.normal,
    this.titleMuted = false,
    this.dataMuted = false,
    this.titleColor = MahasColors.dark,
    this.dataColor = MahasColors.dark,
    this.titleFontWeight = FontWeight.normal,
    this.dataFontWeight = FontWeight.normal,
    this.isTitleIcon = false,
    this.titleIcon,
    this.isDataIcon = false,
    this.dataIcon,
    this.titleIconAlign = Alignment.bottomLeft,
    this.dataIconAlign = Alignment.bottomLeft,
    this.titleOnTap,
    this.dataOnTap,
    this.isCustomDataWidget = false,
    this.dataCustomWidget,
    this.isLoading = false,
    this.isWithColon = true,
    this.isInPixel = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MahasWidget.loadingWidget(
                customWidget: MahasWidget.customLoadingWidget(
                    width: Get.width * titleWidth),
              ),
              Container(
                width: 15,
                color: MahasColors.light,
              ),
              Expanded(
                child: MahasWidget.loadingWidget(
                  customWidget: MahasWidget.customLoadingWidget(),
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isInPixel ? titleWidth : Get.width * titleWidth,
                child: isTitleIcon
                    ? Align(
                        alignment: titleIconAlign,
                        child: Icon(
                          titleIcon ?? Icons.person,
                          size: 25,
                        ),
                      )
                    : TextComponent(
                        padding: padding,
                        value: title,
                        fontColor: titleColor,
                        maxLines: titleMaxLines,
                        textAlign: titleAlign,
                        isMuted: titleMuted,
                        fontWeight: titleFontWeight,
                        onTap: titleOnTap,
                        fontSize: titleFontSize,
                      ),
              ),
              TextComponent(
                margin: EdgeInsets.symmetric(
                  horizontal: colonMargin ?? 0,
                ),
                padding: padding,
                value: isWithColon? ":" :"",
              ),
              Expanded(
                child: isCustomDataWidget
                    ? SizedBox(
                        child: dataCustomWidget,
                      )
                    : SizedBox(
                        width: Get.width,
                        child: isDataIcon
                            ? Align(
                                alignment: dataIconAlign,
                                child: Icon(
                                  dataIcon ?? Icons.person,
                                  size: 25,
                                ),
                              )
                            : TextComponent(
                                padding: padding,
                                value: data,
                                fontColor: dataColor,
                                maxLines: dataMaxLines,
                                textAlign: dataAlign,
                                isMuted: dataMuted,
                                fontWeight: dataFontWeight,
                                onTap: dataOnTap,
                                fontSize: dataFontSize,
                              ),
                      ),
              ),
            ],
          );
  }
}
