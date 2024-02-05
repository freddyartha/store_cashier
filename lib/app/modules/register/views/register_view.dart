import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
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
        color: MahasColors.primary,
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
                              SizedBox(
                                height: 45,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Belum",
                                        isMultilineText: true,
                                        borderColor: MahasColors.primary,
                                        btnColor: MahasColors.light,
                                        textColor: MahasColors.dark,
                                        borderRadius: 3,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        onTap: () =>
                                            controller.companyOnTap(false),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Sudah",
                                        isMultilineText: true,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        borderRadius: 3,
                                        btnColor: MahasColors.primary,
                                        onTap: () =>
                                            controller.companyOnTap(true),
                                      ),
                                    ),
                                  ],
                                ),
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
                              SizedBox(
                                height: 45,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Kembali",
                                        isMultilineText: true,
                                        borderColor: MahasColors.primary,
                                        btnColor: MahasColors.light,
                                        textColor: MahasColors.dark,
                                        borderRadius: 3,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        onTap: () {
                                            controller.isInitDone.value = false;
                                            controller.alreadyHaveCompany.value = false;
                                        }
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Simpan",
                                        isMultilineText: true,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        borderRadius: 3,
                                        btnColor: MahasColors.primary,
                                        onTap: () =>
                                            controller.companyOnTap(true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const TextComponent(
                                margin: EdgeInsets.only(top: 20),
                                value:
                                    "*ID Perusahaan dapat dilihat di halaman Profile (Home >> Settings >> Profile) pada akun yang Perusahaannya sudah terdaftar",
                              ),
                            ],
                          ),)
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
                                        controller: controller.namaPerusahaanCon,
                                        isRequired: true,
                                        label: "Nama Perusahaan",
                                        isBorderRectangle: true,
                                        marginBottom: 10,
                                      ),
                                      InputTextComponent(
                                        controller:
                                            controller.alamatPerusahaanCon,
                                        isRequired: true,
                                        label: "Alamat Perusahaan",
                                        isBorderRectangle: true,
                                        marginBottom: 10,
                                      ),
                                      SizedBox(
                                height: 45,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Kembali",
                                        isMultilineText: true,
                                        borderColor: MahasColors.primary,
                                        btnColor: MahasColors.light,
                                        textColor: MahasColors.dark,
                                        borderRadius: 3,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        onTap: () {
                                            controller.isInitDone.value = false;
                                            controller.alreadyHaveCompany.value = false;
                                        }
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Flexible(
                                      child: ButtonComponent(
                                        text: "Simpan",
                                        isMultilineText: true,
                                        fontSize: MahasFontSize.normal,
                                        fontWeight: FontWeight.w600,
                                        borderRadius: 3,
                                        btnColor: MahasColors.primary,
                                        onTap: () =>
                                            controller.companyOnTap(true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                    ],
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
