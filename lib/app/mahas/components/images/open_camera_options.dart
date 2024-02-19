import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../mahas_colors.dart';
import '../../services/helper.dart';
import 'camera_view.dart';
import 'file_document_type.dart';
import 'fullscreen_image_document_component.dart';
import 'image_component.dart';
import 'photo_type.dart';
import 'upload_image_component.dart';

typedef PathImageDocumentSelectedCallback = void Function(List<String> path);

class OpenCameraOptions {
  /// If you wanna just return the path (string), you can use this method
  static Future<List<String>?> getImage(
      BuildContext context, PhotoType photoType,
      {String? source,
      List<String> extendsionAllowed = const ['jpg', 'png', 'jpeg']}) async {
    List<String> file = [];
    if (source == CameraSource.camera.value) {
      final camera = await availableCameras();
      // ignore: use_build_context_synchronously
      return await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return CameraView(
                  cameras: camera,
                  type: photoType,
                );
              },
              fullscreenDialog: false));
    } else if (source == CameraSource.gallery.value) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: photoType == PhotoType.gambar ? true : false,
        type: Platform.isAndroid ? FileType.custom : FileType.image,
        allowedExtensions: Platform.isAndroid ? extendsionAllowed : [],
      );
      if (result != null) {
        for (var e in result.files) {
          file.add(e.path!);
        }
      }
      return file;
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        for (var e in result.files) {
          file.add(e.path!);
        }
      }
      return file;
    }
  }

  /// If you need to open multiple options of how to pick image or document, then please use this method
  // void selectOptionForUploadImageDocument(context,
  //     {PhotoType? photoType,
  //     PathImageDocumentSelectedCallback? pathImageDocumentSelected,
  //     bool showContent = true,
  //     bool showPdfOption = false,
  //     String? customTitle,
  //     String? customContent}) {
  //   List<String> file = [];
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(10.0),
  //               topRight: Radius.circular(10.0))),
  //       context: context,
  //       builder: (builder) {
  //         return SizedBox(
  //           height: 200.0,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: <Widget>[
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               SvgPicture.asset("assets/svg/bottom_sheet_line.svg"),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Text(
  //                 customTitle ?? photoType!.descTitle,
  //                 style: const TextStyle(
  //                     color: Color(0xff3B5FDE), fontWeight: FontWeight.bold),
  //               ),
  //               showContent
  //                   ? Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Text(
  //                         customContent ?? photoType!.content.last,
  //                         textAlign: TextAlign.center,
  //                         style: const TextStyle(
  //                           color: Color(0xff3B5FDE),
  //                         ),
  //                       ),
  //                     )
  //                   : Visibility(visible: false, child: Container()),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 margin: !showPdfOption
  //                     ? const EdgeInsets.only(left: 40, right: 40)
  //                     : null,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () async {
  //                           Navigator.of(context).pop();
  //                           var url = await OpenCameraOptions.getImage(
  //                             context,
  //                             photoType!,
  //                             source: CameraSource.camera.value,
  //                           );
  //                           if (url != null) {
  //                             pathImageDocumentSelected!(url);
  //                           }
  //                         },
  //                         child: Column(
  //                           children: <Widget>[
  //                             SvgPicture.asset(
  //                                 "assets/svg/camera_bottom_sheet.svg"),
  //                             const SizedBox(height: 5),
  //                             const Text(
  //                               "dari kamera",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () async {
  //                           Navigator.of(context).pop();
  //                           List<String> url = [];
  //                           try {
  //                             FilePickerResult? result =
  //                                 await FilePicker.platform.pickFiles(
  //                                     type: Platform.isAndroid
  //                                         ? FileType.custom
  //                                         : FileType.image,
  //                                     allowedExtensions: Platform.isAndroid
  //                                         ? ['png', 'jpg']
  //                                         : []);

  //                             if (result != null) {
  //                               for (var e in result.files) {
  //                                 file.add(e.path!);
  //                               }
  //                               url.clear;
  //                               url.addAll(file);
  //                               if (_megaByte(url) > 3) {
  //                                 _showSizeError(context);
  //                               } else {
  //                                 pathImageDocumentSelected!(url);
  //                               }
  //                             }
  //                           } catch (e) {
  //                             Helper.debugLogger("error pick image = $e");
  //                           }
  //                         },
  //                         child: Column(
  //                           children: <Widget>[
  //                             SvgPicture.asset(
  //                                 "assets/svg/gallery_bottom_sheet.svg"),
  //                             const SizedBox(height: 5),
  //                             const Text(
  //                               "dari gallery",
  //                               style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     if (showPdfOption)
  //                       Expanded(
  //                         child: GestureDetector(
  //                           onTap: () async {
  //                             Navigator.of(context).pop();
  //                             try {
  //                               var url = await getImage(context, photoType!,
  //                                   source: CameraSource.pdf.value);
  //                               if (url != null) {
  //                                 _previewDocument(
  //                                   Get.context!,
  //                                   url,
  //                                   photoType,
  //                                   (String path) =>
  //                                       pathImageDocumentSelected!(path),
  //                                 );
  //                               }
  //                             } catch (e) {
  //                               Helper.debugLogger("error pick image = $e");
  //                             }
  //                           },
  //                           child: const Column(
  //                             children: <Widget>[
  //                               ImageComponent(
  //                                 localUrl: "assets/images/pdf.png",
  //                                 height: 50,
  //                                 width: 50,
  //                               ),
  //                               SizedBox(height: 5),
  //                               Text(
  //                                 "dari folder",
  //                                 style: TextStyle(fontWeight: FontWeight.bold),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // void showEditSheet(BuildContext context, String image, PhotoType type,
  //     {Function()? onEditTapped, Function()? onViewTapped}) {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(10.0),
  //               topRight: Radius.circular(10.0))),
  //       context: context,
  //       builder: (builder) {
  //         return Wrap(
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: <Widget>[
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SvgPicture.asset("assets/svg/bottom_sheet_line.svg"),
  //                 const SizedBox(
  //                   height: 18,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: <Widget>[
  //                     GestureDetector(
  //                       onTap: onEditTapped,
  //                       child: Column(
  //                         children: <Widget>[
  //                           Icon(Icons.edit,
  //                               size: 30, color: MahasColors.primary),
  //                           const SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             "Edit ${isExtesionPdf(image) ? 'Dokumen' : 'Foto'}",
  //                             style:
  //                                 const TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: onViewTapped!,
  //                       child: Column(
  //                         children: <Widget>[
  //                           Icon(Icons.zoom_out_map_rounded,
  //                               size: 30, color: MahasColors.primary),
  //                           const SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             "Lihat ${isExtesionPdf(image) ? 'Dokumen' : 'Foto'}",
  //                             style:
  //                                 const TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   height: 18,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void _previewDocument(BuildContext context, String path, PhotoType photoType,
  //     PathImageDocumentSelectedCallback pathImageDocumentSelected) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => FullScreenImageDocumentComponent(
  //           image: path,
  //           pdfPath: path,
  //           documentSelectedCallBack: (boolean) async {
  //             if (boolean) {
  //               if (_megaByte(path) > 10) {
  //                 _showSizeError(context, isPdf: true);
  //               } else {
  //                 pathImageDocumentSelected(path);
  //               }
  //             } else {
  //               await getImage(context, photoType,
  //                       source: CameraSource.pdf.value)
  //                   .then((value) => _previewDocument(
  //                       context, value!, photoType, pathImageDocumentSelected));
  //             }
  //           }),
  //     ),
  //   );
  // }

  // double _megaByte(List<String> docPath) {
  //   // List<int> bytes = [];
  //   for (var e in docPath) {
  //     var bytes = File(e).readAsBytesSync().lengthInBytes;
  //     return (bytes / 1024) / 1024;
  //   }
  // }

  // _showSizeError(BuildContext context, {bool isPdf = false}) {
  //   return Helper.dialogWarning(
  //       "Ukuran maksimal file ${isPdf ? "PDF 10MB" : "gambar 3MB"}");
  // }
}
