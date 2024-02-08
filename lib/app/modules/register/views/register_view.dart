import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_checkbox_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MahasWidget.safeAreaWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SizedBox(
            height: Get.height,
            child: Stack(
              children: [
                MahasWidget.backgroundWidget(),
                !controller.isInitDone.value
                    ? Center(
                        child: MahasWidget.uniformCardWidget(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const TextComponent(
                                textAlign: TextAlign.center,
                                value: "Apakah kamu sudah memiliki Perusahaan?",
                                fontSize: MahasFontSize.h6,
                                margin: EdgeInsets.only(bottom: 20),
                              ),
                              MahasWidget.horizontalTwoButtonWidget(
                                leftButtonOnTap: () =>
                                    controller.companyOnTap(false),
                                rightButtonOnTap: () =>
                                    controller.companyOnTap(true),
                                leftButtonText: "Belum",
                                rightButtonText: "Sudah",
                              ),
                            ],
                          ),
                        ),
                      )
                    : controller.isInitDone.value &&
                            controller.alreadyHaveCompany.value
                        ? MahasWidget.uniformCardWidget(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InputTextComponent(
                                  controller: controller.idPerusahaanCon,
                                  isRequired: true,
                                  label: "Masukkan ID Perusahaan",
                                  isBorderRectangle: true,
                                  marginBottom: 30,
                                ),
                                MahasWidget.horizontalTwoButtonWidget(
                                  rightButtonText: "Masukan",
                                  leftButtonOnTap: () {
                                    controller.isInitDone.value = false;
                                    controller.alreadyHaveCompany.value = false;
                                  },
                                  rightButtonOnTap:
                                      controller.namaPerusahaanOnSave,
                                ),
                                const TextComponent(
                                  margin: EdgeInsets.only(top: 20),
                                  value:
                                      "*ID Perusahaan dapat dilihat di halaman Profile (Home >> Settings >> Profile) pada akun yang Perusahaannya sudah terdaftar",
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                const TextComponent(
                                  value: "Form Registrasi",
                                  fontSize: MahasFontSize.h3,
                                  fontColor: MahasColors.light,
                                  fontWeight: FontWeight.bold,
                                  margin: EdgeInsets.only(bottom: 15),
                                ),
                                MahasWidget.uniformCardWidget(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InputTextComponent(
                                          controller: controller.namaLengkapCon,
                                          isRequired: true,
                                          label: "Nama Lengkap",
                                          isBorderRectangle: true,
                                          marginBottom: 10,
                                        ),
                                        InputTextComponent(
                                          controller: controller.noHandphoneCon,
                                          isRequired: true,
                                          label: "No. Handphone",
                                          isBorderRectangle: true,
                                          marginBottom: 10,
                                        ),
                                        InputTextComponent(
                                          controller: controller.alamatCon,
                                          isRequired: true,
                                          label: "Alamat",
                                          isBorderRectangle: true,
                                          marginBottom: 10,
                                        ),
                                        InputTextComponent(
                                          controller:
                                              controller.namaPerusahaanCon,
                                          isRequired: true,
                                          label: "Nama Perusahaan",
                                          isBorderRectangle: true,
                                          marginBottom: 10,
                                        ),
                                        InputCheckboxComponent(
                                          controller: controller.alamatIsSame,
                                          label:
                                              "Alamat Perusahaan sama dengan Alamat Rumah",
                                          isSwitch: true,
                                        ),
                                        Visibility(
                                          visible: !controller.checked.value,
                                          child: InputTextComponent(
                                            controller:
                                                controller.alamatPerusahaanCon,
                                            isRequired: true,
                                            label: "Alamat Perusahaan",
                                            isBorderRectangle: true,
                                            marginBottom: 30,
                                          ),
                                        ),
                                        MahasWidget.horizontalTwoButtonWidget(
                                          leftButtonOnTap: () {
                                            controller.isInitDone.value = false;
                                            controller.alreadyHaveCompany.value =
                                                false;
                                          },
                                          rightButtonOnTap:
                                              controller.registrasiOnSave,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
