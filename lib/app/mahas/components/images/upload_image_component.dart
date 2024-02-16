import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../mahas_colors.dart';
import '../buttons/button_component.dart';
import 'fullscreen_image_document_component.dart';
import 'photo_type.dart';

enum CameraSource { camera, gallery, pdf }

extension CameraSourceExtension on CameraSource {
  String get value {
    switch (this) {
      case CameraSource.camera:
        return "camera";
      case CameraSource.gallery:
        return "gallery";
      case CameraSource.pdf:
        return "pdf";
      default:
        return "N/A";
    }
  }
}

class UploadImageComponent extends StatefulWidget {
  final Function(String)? onTapGetImage;
  final PhotoType photoType;
  final String? imagePath;
  final bool isRequired;
  final Color colorLineAndIcon;
  final double? height;
  final double? width;
  const UploadImageComponent(
      {super.key,
      @required this.onTapGetImage,
      this.colorLineAndIcon = MahasColors.dark,
      this.isRequired = false,
      this.photoType = PhotoType.ktp,
      this.height,
      this.width,
      @required this.imagePath});

  @override
  State<UploadImageComponent> createState() => _UploadImageComponentState();
}

class _UploadImageComponentState extends State<UploadImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.imagePath == null || widget.imagePath == ""
            ? framePickImage()
            : imageDoc(widget.imagePath!),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.photoType.descTitle.replaceAll("Foto ", ""),
              textAlign: TextAlign.center,
            ),
            Visibility(
                visible: widget.isRequired,
                child: const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
        Visibility(
            visible: widget.imagePath != null && widget.imagePath != "",
            child: InkWell(
              onTap: () {
                showEditSheet(widget.imagePath!, widget.photoType);
              },
              child: const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    "Ganti Foto",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  void showEditSheet(String image, PhotoType type) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        context: context,
        builder: (builder) {
          return Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  SvgPicture.asset("assets/svg/bottom_sheet_line.svg"),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          widget.photoType == PhotoType.familyCard ||
                                  widget.photoType == PhotoType.gambar
                              ? _settingModalBottomSheet(context)
                              : showBotSheet(widget.photoType);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.edit,
                                size: 30, color: MahasColors.primary),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Edit Foto",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImageDocumentComponent(
                                image: image,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.zoom_out_map_rounded,
                                size: 30, color: MahasColors.primary),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Lihat Foto",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget imageDoc(String image) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        strokeWidth: 1,
        dashPattern: const [4, 0],
        color: widget.colorLineAndIcon,
        padding: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => FullScreenImageDocumentComponent(
                  image: image,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: FadeInImage(
              placeholder: const AssetImage("assets/images/loading_lands.gif"),
              image: Image.file(File(image)).image,
              height: widget.width == null
                  ? Get.width / 4.5
                  : Get.width / widget.width!,
              width: widget.height == null
                  ? Get.width / 3
                  : Get.width / widget.height!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget framePickImage() {
    return InkWell(
      onTap: () {
        widget.photoType == PhotoType.familyCard ||
                widget.photoType == PhotoType.gambar
            ? _settingModalBottomSheet(context)
            : showBotSheet(widget.photoType);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          strokeWidth: 1,
          dashPattern: const [4, 4],
          color: widget.colorLineAndIcon,
          padding: const EdgeInsets.all(0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: SizedBox(
              height: widget.width == null
                  ? Get.width / 4.5
                  : Get.width / widget.width!,
              width: widget.height == null
                  ? Get.width / 3
                  : Get.width / widget.height!,
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 34,
                color: widget.colorLineAndIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBotSheet(PhotoType type) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Upload ${type.descTitle}",
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
                          type.title == "GAMBAR"
                              ? const SizedBox(height: 20)
                              : descUploadGuide(type),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ButtonComponent(
                                text: "Ambil ${type.descTitle}",
                                textColor: MahasColors.light,
                                btnColor: MahasColors.primary,
                                borderRadius: 6.0,
                                onTap: () => widget
                                    .onTapGetImage!(CameraSource.camera.value)),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        context: context,
        builder: (builder) {
          return SizedBox(
            height: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                SvgPicture.asset("assets/svg/bottom_sheet_line.svg"),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.photoType.descTitle,
                  style: const TextStyle(
                      color: Color(0xff3B5FDE), fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.photoType.content.last,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff3B5FDE),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () =>
                          widget.onTapGetImage!(CameraSource.camera.value),
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/svg/camera_bottom_sheet.svg"),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "dari kamera",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          widget.onTapGetImage!(CameraSource.gallery.value),
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/svg/gallery_bottom_sheet.svg"),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "dari gallery",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget descUploadGuide(PhotoType type) {
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
                    child: Image(image: AssetImage(type.image[0])),
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
                    child: Image(image: AssetImage(type.image[1])),
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
        contentUpl(type)
      ],
    );
  }

  Widget contentUpl(PhotoType type) {
    List<Widget> widgets = [];
    for (var element in type.content) {
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
