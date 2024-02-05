import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mahas_colors.dart';
import '../buttons/button_component.dart';
import 'image_component.dart';
import 'photo_type.dart';
import 'upload_image_component.dart';

class TakeImageGuide {
  void showBotSheet(BuildContext context, PhotoType type,
      {Function(CameraSource)? onTapGetImage,
      Widget? customButtonWidget,
      bool isDraggable = false,
      String? customTitle,
      String? customContent,
      Widget? customHeaderBottomSheet}) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return isDraggable
              ? DraggableScrollableSheet(
                  initialChildSize: 0.8,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) => Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          children: [
                            customHeaderBottomSheet ??
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Upload ${customTitle ?? type.descTitle}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.black.withOpacity(0.5),
                                        ))
                                  ],
                                ),
                            Expanded(
                                child: ListView(
                              shrinkWrap: true,
                              children: [
                                descUploadGuide(type,
                                    customContent:
                                        customContent?.split(". ").toList()),
                              ],
                            )),
                            const SizedBox(height: 16),
                            customButtonWidget ??
                                SizedBox(
                                  width: double.infinity,
                                  child: ButtonComponent(
                                    text: "Ambil ${type.descTitle}",
                                    borderRadius: 6.0,
                                    textColor: MahasColors.light,
                                    btnColor: MahasColors.primary,
                                    onTap: () =>
                                        onTapGetImage!(CameraSource.camera),
                                  ),
                                ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            children: [
                              customHeaderBottomSheet ??
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Upload ${customTitle ?? type.descTitle}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(
                                            Icons.clear_rounded,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ))
                                    ],
                                  ),
                              descUploadGuide(type,
                                  customContent:
                                      customContent?.split(". ").toList()),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ButtonComponent(
                                    text:
                                        "Ambil ${customTitle ?? type.descTitle}",
                                    btnColor: MahasColors.primary,
                                    textColor: MahasColors.light,
                                    borderRadius: 6.0,
                                    fontWeight: FontWeight.bold,
                                    onTap: () =>
                                        onTapGetImage!(CameraSource.camera)),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
        });
  }

  Widget descUploadGuide(PhotoType type, {List<String>? customContent}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width / 2.5,
                    child: ImageComponent(
                      localUrl: type.image[0],
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Benar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: MahasColors.green),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width / 2.5,
                    child: ImageComponent(
                      localUrl: type.image[1],
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Salah",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: MahasColors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        contentUpl(type, customContent: customContent)
      ],
    );
  }

  Widget contentUpl(PhotoType type, {List<String>? customContent}) {
    List<Widget> widgets = [];
    List<String> contents = customContent ?? type.content;
    for (var element in contents) {
      widgets.add(const SizedBox(height: 6));
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.circle,
                color: Colors.black.withOpacity(0.6), size: 6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              element,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ));
    }
    return Column(children: widgets);
  }
}
