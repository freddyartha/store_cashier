import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../services/helper.dart';
import 'image_component.dart';

typedef DocumentSelectedCallBack = void Function(bool isSelected);

class FullScreenImageDocumentComponent extends StatefulWidget {
  final String? image;
  final Color? color;
  final String? pdfPath;
  final bool? onlyPreviewAfterBrowse;
  final DocumentSelectedCallBack? documentSelectedCallBack;

  const FullScreenImageDocumentComponent(
      {super.key,
      this.image,
      this.color,
      this.pdfPath,
      this.documentSelectedCallBack,
      this.onlyPreviewAfterBrowse = false});

  @override
  // ignore: library_private_types_in_public_api
  _FullScreenImageDocumentComponentState createState() =>
      _FullScreenImageDocumentComponentState();
}

class _FullScreenImageDocumentComponentState
    extends State<FullScreenImageDocumentComponent> {
  bool _isReady = false;
  String errorMessage = "Gagal memuat halaman, silakan coba lagi.";

  bool isImageUrl(String path) {
    return path.contains('http');
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _isReady = widget.documentSelectedCallBack == null ? true : false;
    });
    return Scaffold(
      body: widget.image == null
          ? const ImageComponent(
              localUrl: "null",
            )
          : widget.image.toString().toLowerCase().contains("HTTP")
              ? ImageComponent(
                  networkUrl: widget.image,
                )
              : widget.documentSelectedCallBack != null &&
                      widget.onlyPreviewAfterBrowse!
                  ? ImageComponent(
                      imageFromFile: widget.image,
                    )
                  : Stack(
                      children: [
                        widget.documentSelectedCallBack != null ||
                                widget.onlyPreviewAfterBrowse!
                            ? SfPdfViewer.file(File(
                                widget.pdfPath!,
                              ))
                            : SfPdfViewer.network(
                                widget.pdfPath!,
                                onDocumentLoadFailed: (failed) {
                                  setState(() {
                                    _isReady = true;
                                  });
                                  Helper.dialogWarning(errorMessage);
                                },
                                onDocumentLoaded: (loaded) {
                                  setState(() {
                                    _isReady = true;
                                  });
                                },
                              ),
                        Visibility(
                          visible: !_isReady &&
                              widget.documentSelectedCallBack == null,
                          child: const CircularProgressIndicator(),
                        )
                      ],
                    ),
      floatingActionButton: widget.onlyPreviewAfterBrowse!
          ? FloatingActionButton(
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              })
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    child: const Icon(Icons.delete),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      widget.documentSelectedCallBack!(false);
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                FloatingActionButton(
                  heroTag: "btn2",
                  child: const Icon(Icons.check_circle),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    widget.documentSelectedCallBack!(true);
                  },
                )
              ],
            ),
      floatingActionButtonLocation: widget.documentSelectedCallBack == null
          ? FloatingActionButtonLocation.endTop
          : FloatingActionButtonLocation.endDocked,
    );
  }
}
