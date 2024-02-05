import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../mahas_widget.dart';

class TextComponent extends StatelessWidget {
  final String? value;
  final Color fontColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool isMuted;
  final TextAlign textAlign;
  final int? maxLines;
  final Function()? onTap;
  final EdgeInsetsGeometry margin;
  final bool isLoading;
  const TextComponent({
    super.key,
    @required this.value,
    this.fontColor = MahasColors.dark,
    this.onTap,
    this.isMuted = false,
    this.fontWeight = FontWeight.normal,
    this.fontSize = MahasFontSize.normal,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MahasWidget.loadingWidget(
            customWidget: MahasWidget.customLoadingWidget(),
          )
        : Container(
            margin: margin,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: padding,
                child: Text(
                  value!,
                  maxLines: maxLines,
                  // style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: fontColor.withOpacity(isMuted ? .9 : 1),),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: fontColor.withOpacity(isMuted ? .7 : 1),
                    ),
                  ),
                  textAlign: textAlign,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                ),
              ),
            ),
          );
  }
}
