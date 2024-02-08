import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/login_button.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';

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
                          LoginButton(
                            onPressed: controller.googleLoginOnPress,
                            type: LoginButtonType.google,
                          ),
                          Visibility(
                            visible: Platform.isIOS,
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: LoginButton(
                                onPressed: controller.appleLoginOnPress,
                                type: LoginButtonType.apple,
                              ),
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
