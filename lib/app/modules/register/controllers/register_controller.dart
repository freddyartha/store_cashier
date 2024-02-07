import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final InputTextController namaLengkapCon = InputTextController();
  final InputTextController namaPerusahaanCon = InputTextController();
  final InputTextController noHandphoneCon =
      InputTextController(type: InputTextType.phone);
  final InputTextController alamatCon =
      InputTextController(type: InputTextType.paragraf);
  final InputTextController alamatPerusahaanCon =
      InputTextController(type: InputTextType.paragraf);

  final InputTextController idPerusahaanCon = InputTextController();

  RxBool alreadyHaveCompany = false.obs;
  RxBool isInitDone = false.obs;

  void companyOnTap(bool already) {
    alreadyHaveCompany.value = already;
    isInitDone.value = true;
  }

  Future<void> namaPerusahaanOnSave() async {
    if (idPerusahaanCon.isValid) {
      MahasService.loadingOverlay(true);
      var getCompany = MahasConfig.firestore
          .collection("company")
          .doc(idPerusahaanCon.value);

      DocumentSnapshot querySnapshot = await getCompany.get();
      if (querySnapshot.exists) {
        await getCompany.update(
          {
            'user_id': FieldValue.arrayUnion(
              [auth.currentUser!.uid],
            )
          },
        ).timeout(
          Duration(seconds: MahasConfig.timeLimit),
          onTimeout: () {
            Helper.errorToast();
            return;
          },
        );
        showMaterialModalBottomSheet(
          context: Get.context!,
          builder: (builder) => MahasWidget.safeAreaWidget(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SizedBox(
                height: Get.height,
                child: Stack(
                  children: [
                    MahasWidget.backgroundWidget(),
                    Column(
                      children: [
                        MahasWidget.uniformCardWidget(
                          child: Column(
                            children: [
                              TextComponent(
                                value:
                                    "ID Perusahaan berhasil ditemukan! Silahkan isi data diri kamu untuk melanjutkan ke Beranda",
                                fontColor: MahasColors.primary,
                                fontSize: MahasFontSize.h6,
                                fontWeight: FontWeight.w600,
                                margin: const EdgeInsets.only(bottom: 30),
                              ),
                              InputTextComponent(
                                controller: namaLengkapCon,
                                isRequired: true,
                                label: "Nama Lengkap",
                                isBorderRectangle: true,
                                marginBottom: 10,
                              ),
                              InputTextComponent(
                                controller: noHandphoneCon,
                                isRequired: true,
                                label: "No. Handphone",
                                isBorderRectangle: true,
                                marginBottom: 10,
                              ),
                              InputTextComponent(
                                controller: alamatCon,
                                isRequired: true,
                                label: "Alamat",
                                isBorderRectangle: true,
                                marginBottom: 40,
                              ),
                              SizedBox(
                                height: 45,
                                child: ButtonComponent(
                                  text: "Simpan",
                                  isMultilineText: false,
                                  fontSize: MahasFontSize.h6,
                                  fontWeight: FontWeight.w600,
                                  btnColor: MahasColors.primary,
                                  borderRadius: MahasThemes.borderRadius / 2,
                                  onTap: bottomSheetSubmit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        Helper.errorToast(message: "ID Perusahaan tidak ditemukan");
      }
      EasyLoading.dismiss();
    }
  }

  Future<void> bottomSheetSubmit() async {
    if (namaLengkapCon.isValid && noHandphoneCon.isValid && alamatCon.isValid) {
      MahasService.loadingOverlay(true);
      Map<String, dynamic> userModel = {
        "nama": namaLengkapCon.value,
        "no_hp": noHandphoneCon.value,
        "alamat": alamatCon.value,
        "company_id": idPerusahaanCon.value,
      };
      try {
        await MahasConfig.firestore.collection("user").add(userModel);
        EasyLoading.dismiss();
        _toHome();
      } on FirebaseException catch (e) {
        EasyLoading.dismiss();
        Helper.errorToast(message: e.message);
      } catch (e) {
        EasyLoading.dismiss();
        Helper.errorToast(message: e.toString());
      }
    }
  }

  void _toHome() {
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> registrasiOnSave() async {
    if (namaLengkapCon.isValid &&
        noHandphoneCon.isValid &&
        alamatCon.isValid &&
        namaPerusahaanCon.isValid &&
        alamatPerusahaanCon.isValid) {
      MahasService.loadingOverlay(true);
      Map<String, dynamic> companyModel = {
        "user_id": [auth.currentUser!.uid],
        "nama_perusahaan": namaPerusahaanCon.value,
        "alamat_perusahaan": alamatPerusahaanCon.value,
      };

      try {
        var data =
            await MahasConfig.firestore.collection("company").add(companyModel);
        Map<String, dynamic> userModel = {
          "nama": namaLengkapCon.value,
          "no_hp": noHandphoneCon.value,
          "alamat": alamatCon.value,
          "company_id": data.id,
        };
        await MahasConfig.firestore.collection("user").add(userModel);
        EasyLoading.dismiss();
        _toHome();
      } on FirebaseException catch (e) {
        EasyLoading.dismiss();
        Helper.errorToast(message: e.message);
      } catch (e) {
        EasyLoading.dismiss();
        Helper.errorToast(message: e.toString());
      }
    }
  }
}
