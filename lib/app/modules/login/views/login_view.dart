import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/buttons/login_button.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';

import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/components/texts/text_component.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MahasWidget.safeAreaWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          reverse: true,
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            height: Get.height,
            child: Stack(
              children: [
                MahasWidget.backgroundWidget(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 100,
                      ),
                    ),
                    MahasWidget.uniformCardWidget(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InputTextComponent(
                            controller: controller.emailCon,
                            isRequired: true,
                            label: "Email",
                            isBorderRectangle: true,
                            marginBottom: 10,
                          ),
                          InputTextComponent(
                            controller: controller.passwordCon,
                            isRequired: true,
                            isBorderRectangle: true,
                            marginBottom: 25,
                            label: "Password",
                          ),
                          ButtonComponent(
                            onTap: controller.emailLoginOnPressed,
                            text: "Masuk",
                            fontSize: MahasFontSize.h6,
                            fontWeight: FontWeight.w600,
                            textColor: MahasColors.light,
                            btnColor: MahasColors.primary,
                            borderColor: MahasColors.primary,
                            borderRadius: MahasThemes.borderRadius / 2,
                          ),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  height: 40,
                                  thickness: 1,
                                  color: MahasColors.greyFontColorMain,
                                ),
                              ),
                              TextComponent(
                                value: "Atau",
                                fontWeight: FontWeight.w500,
                                fontColor: MahasColors.greyFontColorMain,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  height: 40,
                                  thickness: 1,
                                  color: MahasColors.greyFontColorMain,
                                ),
                              ),
                            ],
                          ),
                          LoginButton(
                            onPressed: controller.googleLoginOnPress,
                            type: LoginButtonType.google,
                          ),
                          Visibility(
                            visible: Platform.isIOS,
                            child: LoginButton(
                              onPressed: controller.appleLoginOnPress,
                              type: LoginButtonType.apple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
