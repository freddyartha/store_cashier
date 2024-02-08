import 'package:flutter/material.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import '../../mahas_colors.dart';

class EmptyComponent extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isCard;
  final Color textColor;

  const EmptyComponent({
    super.key,
    this.onPressed,
    this.isCard = false,
    this.textColor = MahasColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isCard
          ? MahasWidget.uniformCardWidget(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: EmptyWidget(
                  onPressed: onPressed,
                  textColor: textColor,
                ),
              ),
            )
          : EmptyWidget(
              onPressed: onPressed,
              textColor: textColor,
            ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.onPressed,
    this.textColor = MahasColors.dark,
  });

  final VoidCallback? onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/not_found.png",
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width * 0.3,
          ),
          TextComponent(
            margin: const EdgeInsets.only(top: 30),
            value: "Data Tidak Ditemukan",
            fontSize: MahasFontSize.h5,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            fontColor: textColor,
          ),
          const SizedBox(
            height: 40,
          ),
          Visibility(
            visible: onPressed != null ? true : false,
            child: ButtonComponent(
              onTap: onPressed ?? () {},
              text: "Refresh",
              fontSize: MahasFontSize.h6,
              fontWeight: FontWeight.w600,
              textColor: textColor,
              btnColor: MahasColors.primary,
              borderColor: MahasColors.light,
              borderRadius: MahasThemes.borderRadius,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
