import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_box_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';

class FirebaseImageController {
  String? _errorMessage;
  late bool _required;
  final List<String> _files = [];
  final List<PlatformFile> _filesRaw = [];
  bool _isInit = false;

  FirebaseImageController();

  late Function(VoidCallback fn) setState;
  BuildContext? context;
  Function()? onChanged;

  dynamic get values {
    if (_files.isNotEmpty) {
      return _files;
    } else if (_filesRaw.isNotEmpty) {
      return _filesRaw;
    }
  }

  set values(dynamic values) {
    _files.addAll(values);
  }

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

  Future<void> _viewFilesOnPressed(PlatformFile imageFile) async {
    Helper.dialogFileComponent(
      [
        ClipRRect(
          borderRadius: BorderRadius.circular(MahasThemes.borderRadius / 2),
          child: Image.file(
            File(imageFile.path!),
          ),
        ),
      ],
    );
  }

  Future<void> _viewLinksOnPressed(String imageLinks) async {
    Helper.dialogFileComponent(
      [
        ClipRRect(
          borderRadius: BorderRadius.circular(MahasThemes.borderRadius / 2),
          child: Image.network(
            imageLinks,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  void _onTab(bool editable) async {
    if (!editable) return;
    _files.clear();
    _filesRaw.clear();
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result!.files.isEmpty) return;
    setState(() {
      _filesRaw.addAll(result.files);
    });
  }

  void _init(Function(VoidCallback fn) setStateX, BuildContext contextX) {
    setState = setStateX;
    context = contextX;
    _isInit = true;
  }

  void _clearOnTab() {
    _files.clear();
    _filesRaw.clear();
    if (_isInit) {
      setState(() {});
    }
    if (onChanged != null) {
      onChanged!();
    }
  }

  void _clearIndexOnTab(int index) {
    if (_files.isNotEmpty) {
      _files.remove(_files[index]);
    } else if (_filesRaw.isNotEmpty) {
      _filesRaw.remove(_filesRaw[index]);
    }

    if (_isInit) {
      setState(() {});
    }
    if (onChanged != null) {
      onChanged!();
    }
  }
}

class FirebaseImageComponent extends StatefulWidget {
  final FirebaseImageController controller;
  final bool editable;
  final String? label;
  final bool required;
  final String? placeHolder;

  const FirebaseImageComponent({
    Key? key,
    required this.controller,
    this.editable = true,
    this.label,
    this.required = false,
    this.placeHolder = "Upload Lampiran (Max 2MB) *",
  }) : super(key: key);

  @override
  FirebaseImageComponentState createState() => FirebaseImageComponentState();
}

class FirebaseImageComponentState extends State<FirebaseImageComponent> {
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
          errorMessage: widget.controller._errorMessage,
          label: widget.label,
          children: !widget.editable
              ? widget.label == null
                  ? const TextComponent(
                      value: "Lampiran",
                      isMuted: true,
                      textAlign: TextAlign.start,
                      fontSize: MahasFontSize.h6,
                    )
                  : const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: !widget.editable
                          ? null
                          : () {
                              widget.controller._onTab(true);

                              setState(() {
                                _viewImage();
                              });
                            },
                      child: DottedBorder(
                        borderPadding: const EdgeInsets.all(2),
                        radius: const Radius.circular(MahasThemes.borderRadius),
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        color: widget.controller._errorMessage == null
                            ? MahasColors.dark
                            : MahasColors.danger,
                        dashPattern: const [5, 3],
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MahasThemes.borderRadius),
                            color: MahasColors.dark
                                .withOpacity(widget.editable ? .01 : .05),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextComponent(
                                  value: widget.placeHolder,
                                  isMuted: true,
                                  textAlign: TextAlign.center,
                                  fontSize: MahasFontSize.h6,
                                ),
                              ),
                              Visibility(
                                visible: widget.controller._files.isNotEmpty &&
                                            widget.controller._files.length ==
                                                1 ||
                                        widget.controller._filesRaw
                                                .isNotEmpty &&
                                            widget.controller._filesRaw
                                                    .length ==
                                                1
                                    ? true
                                    : false,
                                child: SizedBox(
                                  width: 35,
                                  height: 40,
                                  child: InkWell(
                                    onTap: widget.controller._clearOnTab,
                                    child: Icon(
                                      FontAwesomeIcons.xmark,
                                      color: MahasColors.danger,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        _viewImage(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _viewImage() {
    return widget.controller._files.isEmpty &&
            widget.controller._filesRaw.isEmpty &&
            !widget.editable
        ? const Text(
            "No File Included",
            style: TextStyle(color: MahasColors.grey),
          )
        : widget.controller._files.length == 1 ||
                widget.controller._filesRaw.length == 1
            ? InkWell(
                onTap: () {
                  if (widget.controller._files.length == 1) {
                    widget.controller
                        ._viewLinksOnPressed(widget.controller._files.first);
                  } else {
                    widget.controller
                        ._viewFilesOnPressed(widget.controller._filesRaw.first);
                  }
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: MahasColors.dark),
                    ),
                    padding: const EdgeInsets.all(5),
                    width: 150,
                    height: 200,
                    child: FadeInImage(
                      placeholder:
                          const AssetImage("assets/images/loading_lands.gif"),
                      image: widget.controller._files.length == 1
                          ? Image.network(widget.controller._files.first).image
                          : Image.file(
                                  File(widget.controller._filesRaw.first.path!))
                              .image,
                    ),
                  ),
                ),
              )
            :
            //buat kondisi gridview
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: widget.controller._files.isNotEmpty
                    ? widget.controller._files.length
                    : widget.controller._filesRaw.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3 - 15,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: MahasColors.dark),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            if (widget.controller._files.length > 1) {
                              widget.controller._viewLinksOnPressed(
                                  widget.controller._files[index]);
                            } else {
                              widget.controller._viewFilesOnPressed(
                                  widget.controller._filesRaw[index]);
                            }
                          },
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                "assets/images/loading_lands.gif"),
                            image: widget.controller._files.length > 1
                                ? Image.network(widget.controller._files[index])
                                    .image
                                : Image.file(
                                    File(widget
                                        .controller._filesRaw[index].path!),
                                  ).image,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (widget.controller._files.length > 1 ||
                                    widget.controller._filesRaw.length > 1) &&
                                widget.editable
                            ? true
                            : false,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () =>
                                widget.controller._clearIndexOnTab(index),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                FontAwesomeIcons.xmark,
                                color: MahasColors.danger,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
  }
}
