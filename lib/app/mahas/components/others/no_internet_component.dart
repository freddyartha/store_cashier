import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import '../../mahas_colors.dart';
import '../mahas_themes.dart';

class NoInternetConnectionPage extends StatelessWidget {
  final Function()? onPressed;
  final String message;

  const NoInternetConnectionPage({
    super.key,
    this.onPressed,
    this.message = "Pastikan internetmu lancar, cek ulang jaringan di tempatmu",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no_internet.png",
              width: Get.width * 0.6,
            ),
            const TextComponent(
              value: "Terjadi Kesalahan!",
              fontSize: MahasFontSize.h3,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              margin: EdgeInsets.only(top: 10),
            ),
            TextComponent(
              value: message,
              fontSize: MahasFontSize.h6,
              textAlign: TextAlign.center,
              margin: const EdgeInsets.only(bottom: 15),
            ),
            Visibility(
              visible: onPressed != null ? true : false,
              child: ButtonComponent(
                onTap: onPressed ?? () {},
                text: "Coba Lagi",
                fontSize: MahasFontSize.h6,
                fontWeight: FontWeight.w600,
                textColor: MahasColors.primary,
                btnColor: Colors.transparent,
                borderColor: MahasColors.primary,
                borderRadius: MahasThemes.borderRadius,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
