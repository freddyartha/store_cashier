import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/others/no_internet_component.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isError.value
            ? NoInternetConnectionPage(onPressed: controller.refreshData)
            : Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          "assets/images/logo.png",
                          scale: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
