import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../../mahas_colors.dart';
import '../../services/helper.dart';
import 'input_box_component.dart';

enum InputFileType { image, pdf, camera }

class InputFileController {
  final List<PlatformFile> _files = [];
  FilePickerResult? result;
  bool mutipleFile = false;
  FileType type;
  String? _errorMessage;
  late bool _required;
  bool _isInit = false;
  String? strBase64;
  List<String> base64String = [];
  List<String> extension = [];
  final dynamic tipe;
  bool urlImage = false;

  InputFileController({
    this.type = FileType.image,
    this.mutipleFile = false,
    this.extension = const ['jpg', 'png'],
    this.tipe = InputFileType.image,
    this.urlImage = false,
  });

  List<PlatformFile> get values {
    return _files;
  }

  dynamic get value {
    if (_files.isEmpty) {
      strBase64 = null;
      return null;
    }
    PlatformFile file = _files.first;
    Uint8List fileBytes = file.bytes!;
    String base64String = base64Encode(fileBytes);
    return base64String;
  }

  dynamic get valueMultiple {
    if (_files.isEmpty) {
      strBase64 = null;
      return null;
    }
    List<String> files = [];
    for (var e in _files) {
      Uint8List fileBytes = compressImage(e.bytes!, 50);
      String base64String = base64Encode(fileBytes);
      files.add(base64String);
    }
    return files;
  }

  dynamic get valueMultipleArray {
    if (_files.isEmpty) {
      strBase64 = null;
      return null;
    }
    List<Uint8List> files = [];
    for (var e in _files) {
      Uint8List fileBytes = compressImage(e.bytes!, 50);
      files.add(fileBytes);
    }
    return files;
  }

  Uint8List compressImage(Uint8List imageBytes, int quality) {
    img.Image image = img.decodeImage(imageBytes)!;
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }

  dynamic get name {
    if (_files.isEmpty) {
      strBase64 = null;
      return null;
    }
    String fileName = _files.first.name;
    return fileName;
  }

  set value(dynamic val) {
    if (val is String) {
      if (urlImage == false) {
        strBase64 = val;
        Uint8List bytes = base64Decode(strBase64!);
        PlatformFile platformFile = PlatformFile(
          name: "file",
          size: bytes.length,
          bytes: bytes,
        );
        _files.add(platformFile);
      } else {
        strBase64 = val;
      }
    } else if (val is List<String>) {
      for (var e in val) {
        base64String.add(e.toString());
      }
    }
  }

  dynamic getPath() async {
    if (_files.isNotEmpty) {
      if (kIsWeb) {
        // return dio.MultipartFile.fromBytes(_files.first.bytes!,
        //     filename: _files.first.name);
      } else {
        // return await dio.MultipartFile.fromFile(_files.single.path!);
      }
    } else {
      return null;
    }
  }

  void addValue(PlatformFile file) {
    _files.add(file);
    if (_isInit) {
      setState(() {});
    }
    if (onChanged != null) {
      onChanged!();
    }
  }

  late Function(VoidCallback fn) setState;
  BuildContext? context;
  Function()? onChanged;

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (_required && _files.isEmpty) {
      setState(() {
        _errorMessage = 'The field is required';
      });
      return false;
    }
    return true;
  }

  String _inputText(bool editable) {
    if (_files.isEmpty) {
      return '';
    } else if (_files.length == 1) {
      return _files[0].name;
    } else {
      return '${_files.length} files';
    }
  }

  Future<void> _viewFileOnPressed() async {
    if (strBase64 == null) return;
    Helper.dialogCustomWidget(
      children: [
        Container(
          child: (tipe == InputFileType.image)
              ? Image.memory(base64Decode(strBase64!))
              : (tipe == InputFileType.pdf)
                  ? SizedBox(
                      width: 300,
                      height: 400,
                      child: PDFView(
                        pdfData: Uint8List.fromList(
                          base64Decode(strBase64!),
                        ),
                      ),
                    )
                  : (tipe == InputFileType.camera && urlImage == true)
                      ? Image.network(strBase64!)
                      : Image.memory(base64Decode(strBase64!)),
        ),
      ],
    );
  }

  void laporanImageOnTap(String url) {
    Helper.dialogFotoStr(
      url,
      "assets/images/logo-nobg.png",
      isNetworkFoto: true,
      radius: 10,
    );
  }

  void _onTab(bool editable) async {
    if (!editable) return;
    if (mutipleFile == false) _files.clear();
    result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: mutipleFile,
      allowedExtensions: extension,
      withData: true,
    );
    if (result!.files.isEmpty) return;
    setState(() {
      _files.addAll(result!.files);
    });
  }

  void _onCameraTab(bool editable) async {
    if (!editable) return;
    if (mutipleFile == false) _files.clear();
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (pickedFile == null) return;
    PlatformFile platformFile = PlatformFile(
      path: pickedFile.path,
      name: pickedFile.name,
      size: await pickedFile.length(),
      bytes: await pickedFile.readAsBytes(),
    );
    setState(() {
      _files.add(platformFile);
    });
  }

  void _init(Function(VoidCallback fn) setStateX, BuildContext contextX) {
    setState = setStateX;
    context = contextX;
    _isInit = true;
  }

  void _clearOnTab() {
    _files.clear();
    if (_isInit) {
      setState(() {});
    }
    if (onChanged != null) {
      onChanged!();
    }
  }
}

class InputFileComponent extends StatefulWidget {
  final InputFileController controller;
  final bool editable;
  final String? label;
  final bool required;
  final double? borderRadius;

  const InputFileComponent({
    super.key,
    required this.controller,
    this.editable = true,
    required this.label,
    this.required = false,
    this.borderRadius,
  });

  @override
  InputFileComponentState createState() => InputFileComponentState();
}

class InputFileComponentState extends State<InputFileComponent> {
  @override
  void initState() {
    widget.controller._required = widget.required;
    widget.controller._init(setState, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputBoxComponent(
          borderRadius: widget.borderRadius,
          icon: !widget.editable
              ? null
              : widget.controller.type == FileType.image
                  ? (widget.controller.mutipleFile
                      ? FontAwesomeIcons.images
                      : Icons.image)
                  : (widget.controller.mutipleFile
                      ? Icons.file_copy
                      : FontAwesomeIcons.file),
          editable: widget.editable,
          label: widget.label,
          onTap: !widget.editable
              ? null
              : () {
                  if (widget.controller.tipe == InputFileType.camera) {
                    widget.controller._onCameraTab(true);
                  } else {
                    widget.controller._onTab(true);
                  }
                },
          childText: widget.controller._inputText(widget.editable),
          alowClear: widget.editable && widget.controller._files.isNotEmpty,
          errorMessage: widget.controller._errorMessage,
          clearOnTab: () => widget.controller._clearOnTab(),
          children: !widget.editable
              ? widget.controller.base64String.isEmpty
                  ? TextButton(
                      onPressed: () {
                        widget.controller.strBase64 == null
                            ? null
                            : widget.controller._viewFileOnPressed();
                      },
                      child: widget.controller.strBase64 == null
                          ? const Text(
                              "No File Included",
                              style: TextStyle(color: MahasColors.grey),
                            )
                          : const Text("View File"),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: widget.controller.base64String.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var item = widget.controller.base64String[index];
                        return InkWell(
                          onTap: () {
                            widget.controller.laporanImageOnTap(item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: (widget.controller.urlImage == true)
                                ? Image.network(item, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  })
                                : Image.memory(
                                    base64Decode(item),
                                  ),
                          ),
                        );
                      },
                    )
              : null,
        ),
        Visibility(
          visible: widget.controller.mutipleFile == true,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: widget.controller._files.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.memory(
                  widget.controller._files[index].bytes!,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
