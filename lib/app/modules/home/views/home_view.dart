import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MahasWidget.safeAreaWidget(
        child: Scaffold(
          body: Stack(
            children: [
              MahasWidget.backgroundWidget(),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextComponent(
                                  value: "Selamat ${controller.greetingText}!",
                                  fontSize: MahasFontSize.h3,
                                  fontWeight: FontWeight.bold,
                                  fontColor: MahasColors.light,
                                  margin: const EdgeInsets.only(bottom: 10),
                                ),
                                TextComponent(
                                  value: MahasConfig.profileModel.nama,
                                  fontColor: MahasColors.light,
                                  fontSize: MahasFontSize.h4,
                                  fontWeight: FontWeight.bold,
                                ),
                                TextComponent(
                                  value:
                                      MahasConfig.companyModel.namaPerusahaan,
                                  fontColor: MahasColors.light,
                                  fontSize: MahasFontSize.h6,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.settingsOnPress,
                          child: const SizedBox(
                            width: 35,
                            height: 30,
                            child: Icon(
                              FontAwesomeIcons.gear,
                              size: 22,
                              color: MahasColors.light,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: controller.signOutOnPress,
                          child: const SizedBox(
                            width: 35,
                            height: 30,
                            child: Icon(
                              FontAwesomeIcons.arrowRightFromBracket,
                              size: 22,
                              color: MahasColors.light,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: Get.width,
                      child: MahasWidget.uniformCardWidget(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MahasService.isTablet &&
                                    MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                ? 3
                                : MahasService.isTablet &&
                                        MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                    ? 4
                                    : 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: controller.menus.length,
                          itemBuilder: (context, index) {
                            var menu = controller.menus[index];
                            return InkWell(
                              onTap: menu.onTab,
                              child: MahasWidget.uniformCardWidget(
                                margin: const EdgeInsets.all(5),
                                color: MahasColors.primary,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      menu.assetImage ??
                                          "assets/images/medicalhistory.png",
                                      height: MahasService.isTablet ? 100 : 65,
                                    ),
                                    TextComponent(
                                      value: menu.title,
                                      fontSize: MahasFontSize.h6,
                                      fontColor: MahasColors.light,
                                      fontWeight: FontWeight.w600,
                                      maxLines: 2,
                                      margin: const EdgeInsets.only(top: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
