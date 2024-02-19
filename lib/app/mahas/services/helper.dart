import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:uuid/uuid.dart';

import '../components/buttons/button_component.dart';
import '../components/images/image_component.dart';
import '../components/texts/text_component.dart';
import '../mahas_colors.dart';
import '../components/mahas_themes.dart';
import '../mahas_widget.dart';

class Helper {
  static Future<bool?> dialogConfirmation({
    String? title,
    String? message,
    IconData? icon,
    Widget? content,
    String? textConfirm,
    String? textCancel,
  }) async {
    return await Get.dialog<bool?>(
      AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        actionsPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MahasThemes.borderRadius),
          ),
        ),
        content: Column(
          crossAxisAlignment: title != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: title != null,
              child: Column(
                children: [
                  TextComponent(
                    value: title ?? "",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: MahasColors.lightBorderColor),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Visibility(
              visible: message != null,
              child: TextComponent(
                value: message,
                fontSize: 13,
                fontWeight: title != null ? FontWeight.w400 : FontWeight.w500,
              ),
            ),
            Visibility(
              visible: content != null,
              child: content ?? Container(),
            ),
          ],
        ),
        actions: [
          const Divider(color: MahasColors.lightBorderColor),
          MahasWidget.horizontalTwoButtonWidget(
            leftButtonText: textCancel ?? "Batal",
            rightButtonText: textConfirm ?? "Submit",
            leftButtonOnTap: () {
              Get.back(result: false);
            },
            rightButtonOnTap: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
    );
  }

  static Future<bool?> dialogQuestion({
    String? message,
    IconData? icon,
    bool isWithImageAsset = true,
    String? imageAsset,
    String? textConfirm,
    String? textCancel,
    Color? color,
  }) async {
    return await Get.dialog<bool?>(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MahasThemes.borderRadius),
          ),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isWithImageAsset
                ? Image.asset(
                    imageAsset ?? "assets/images/question_confirmation.png",
                    height: 150,
                  )
                : Icon(
                    icon ?? FontAwesomeIcons.question,
                    color: color ?? MahasColors.primary,
                    size: 40,
                  ),
            // const Padding(padding: EdgeInsets.all(5)),
            TextComponent(
              value: message ?? "",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        actionsPadding: const EdgeInsets.all(10),
        actions: [
          const Divider(color: MahasColors.lightBorderColor),
          MahasWidget.horizontalTwoButtonWidget(
            leftButtonText: textCancel ?? "Batal",
            rightButtonText: textConfirm ?? "OK",
            leftButtonOnTap: () {
              Get.back(result: false);
            },
            rightButtonOnTap: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
    );
  }

  static Future<bool?> dialogUpdate({
    required bool harusUpdate,
    required String versiTerbaru,
  }) async {
    return await Get.dialog<bool?>(
      AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(MahasThemes.borderRadius))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.question,
              color: MahasColors.primary,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              "Versi $versiTerbaru sudah tersedia",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.only(bottom: 0, top: 20, right: 20, left: 20),
        actionsPadding:
            const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
        actions: [
          TextButton(
            child: Text(
              harusUpdate ? "Tutup" : "Nanti",
              style: const TextStyle(
                color: MahasColors.dark,
              ),
            ),
            onPressed: () {
              if (harusUpdate) {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              } else {
                Get.back(result: false);
              }
            },
          ),
          TextButton(
            child: Text(
              "Unduh Sekarang",
              style: TextStyle(
                color: MahasColors.primary,
              ),
            ),
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future dialogFoto(
      {String? networkUrl,
      String? message,
      bool isListFoto = false,
      List<String>? networkUrlList,
      bool withMessage = false}) async {
    await Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MahasThemes.borderRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Get.width,
                minHeight: Get.width * 0.5,
                maxHeight: Get.width,
                maxWidth: Get.width,
              ),
              child: isListFoto
                  ? Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: networkUrlList?.length,
                        itemBuilder: (context, index) {
                          return ImageComponent(
                            zoomable: true,
                            networkUrl: networkUrlList?[index],
                            margin: const EdgeInsets.only(right: 10),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: ImageComponent(
                        networkUrl: networkUrl,
                      ),
                    ),
            ),
            Visibility(
              visible: withMessage,
              child: Container(
                width: Get.width,
                color: MahasColors.primary,
                padding: const EdgeInsets.all(5),
                child: Text(
                  textAlign: TextAlign.center,
                  message ?? "-",
                  style: TextStyle(
                    color: MahasColors.light,
                    backgroundColor: MahasColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future dialogFotoStr(String? fotoUrl, String? fallbackFoto,
      {bool isNetworkFoto = false, double radius = 25}) async {
    await Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MahasThemes.borderRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: Get.width * 0.6,
          padding: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: fotoUrl != null
                ? isNetworkFoto
                    ? Image(
                        image: NetworkImage(fotoUrl),
                      )
                    : Image.memory(
                        base64Decode(fotoUrl),
                        fit: BoxFit.cover,
                      )
                : Image.asset(
                    fallbackFoto ?? "assets/images/logo-nobg.png",
                  ),
          ),
        ),
      ),
    );
  }

  static errorToast({String? message}) {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    return Get.snackbar(
      "",
      "",
      titleText: const TextComponent(
        value: "Terjadi Kesalahan",
        fontSize: MahasFontSize.h6,
        fontWeight: FontWeight.bold,
        fontColor: MahasColors.light,
      ),
      messageText: TextComponent(
        value: message ??
            'Pastikan internetmu lancar, cek ulang jaringan di tempatmu',
        fontColor: MahasColors.light,
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: MahasColors.danger,
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      borderRadius: MahasThemes.borderRadius,
      colorText: MahasColors.light,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static Future dialogWarning(String? message,
      {showButton = false, String text = "OK", Function()? function}) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: MahasColors.red,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(7)),
            Text(
              textAlign: TextAlign.center,
              message ?? "-",
              style: const TextStyle(
                color: MahasColors.dark,
              ),
            ),
            showButton
                ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ButtonComponent(
                      onTap: function!,
                      text: text,
                      btnColor: MahasColors.primary,
                    ),
                  )
                : MahasWidget.hideWidget()
          ],
        ),
      ),
    );
  }

  static Future dialogSuccess(String? message) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.checkToSlot,
              color: MahasColors.primary,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(7)),
            Text(
              textAlign: TextAlign.center,
              message ?? "-",
              style: TextStyle(
                color: MahasColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future dialogCustomWidget({
    required List<Widget> children,
    List<Widget>? actions,
  }) async {
    await Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              MahasThemes.borderRadius,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
        contentPadding:
            const EdgeInsets.only(bottom: 0, top: 20, right: 10, left: 10),
        actionsPadding:
            const EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
        actions: actions,
      ),
    );
  }

  static Future dialogFileComponent(List<Widget> children) async {
    await Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              MahasThemes.borderRadius,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
        contentPadding: const EdgeInsets.all(10),
        actionsPadding:
            const EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Get.back(result: false);
            },
          ),
        ],
      ),
    );
  }

  static Future<List<int>> toByte(File file) async {
    List<int> byteData = await file.readAsBytes();
    return byteData;
  }

  static void backOnPress({
    dynamic result,
    bool questionBack = true,
    bool editable = false,
    dynamic parametes,
  }) async {
    if (questionBack && editable) {
      final r = await Helper.dialogQuestion(
        message: 'Anda yakin ingin kembali ?',
        textConfirm: 'Ya',
      );
      if (r != true) return;
    }
    Get.back(result: result);
  }

  static String idGenerator() {
    const uuid = Uuid();
    var r = uuid.v4();
    return r;
  }

  static dynamic modalMenu(List<Widget> children) async {
    return await showCustomModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(MahasThemes.borderRadius)),
          color: MahasColors.light,
        ),
        child: Column(
          children: children,
        ),
      ),
      containerWidget: (_, animation, child) => SafeArea(
        child: Column(
          children: [Expanded(child: Container()), child],
        ),
      ),
      expand: false,
    );
  }

  static List<DateTime> calculateDaysInterval(
      DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  static debugLogger(dynamic value, {LoggerType loggerType = LoggerType.info}) {
    if (!kReleaseMode && loggerType == LoggerType.info) Logger().i(value);
    if (!kReleaseMode && loggerType == LoggerType.error) Logger().e(value);
    if (!kReleaseMode && loggerType == LoggerType.debug) Logger().d(value);
  }
}

enum LoggerType { error, info, debug }
