import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../mahas_widget.dart';
import '../../models/api_result_model.dart';
import '../../services/helper.dart';
import '../../services/http_api.dart';
import '../images/image_component.dart';
import '../others/shimmer_component.dart';
import '../texts/text_component.dart';

enum SetupPageState {
  create,
  update,
  detail,
}

class SetupPageController<T> extends ChangeNotifier {
  final String Function(dynamic id)? urlApiGet;
  final String Function()? urlApiPost;
  final String Function(dynamic id)? urlApiPut;
  final String Function(dynamic id)? urlApiDelete;
  final dynamic Function(dynamic e) itemKey;
  final dynamic Function(dynamic e) itemIdAfterSubmit;
  late Function(VoidCallback fn) setState;

  final bool useThisBackAction;
  final bool withQuestionBack;
  bool allowDelete;
  bool allowEdit;
  bool autoBack;
  String contentType;
  final bool isFormData;
  final dynamic pageBackParametes;
  bool editable = false;

  Function()? initState;
  Function()? onSubmit;
  Function()? onInit;
  Function(ApiResultModel)? onSuccessSubmit;

  dynamic _id;
  bool _backRefresh = false;

  dynamic model;
  bool Function()? onBeforeSubmit;
  Function(dynamic id)? bodyApi;
  Function(dynamic json)? apiToView;
  BuildContext? context;

  bool _isLoading = true;

  SetupPageController({
    this.urlApiGet,
    this.urlApiPost,
    this.urlApiPut,
    this.urlApiDelete,
    required this.itemKey,
    this.allowDelete = true,
    this.allowEdit = true,
    this.autoBack = false,
    this.contentType = "application/json",
    this.withQuestionBack = true,
    this.pageBackParametes,
    required this.itemIdAfterSubmit,
    this.onBeforeSubmit,
    this.onSuccessSubmit,
    this.bodyApi,
    this.isFormData = false,
    this.apiToView,
    this.onInit,
    this.useThisBackAction = true,
  });

  void _init({
    Function(VoidCallback fn)? setStateX,
    BuildContext? contextX,
  }) async {
    if (setStateX != null) {
      setState = setStateX;
    }
    if (contextX != null) {
      context = contextX;
    }
    setState(() {
      _isLoading = true;
    });
    if (initState != null) {
      await initState!();
    }
    dynamic idX = itemKey(Get.parameters);
    if (onInit != null) {
      await onInit!();
    }
    if (idX != null) {
      await _getModelFromApi(idX);
    } else {
      editable = true;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _getModelFromApi(dynamic idX) async {
    if (urlApiGet != null) {
      final r = await HttpApi.get(urlApiGet!(idX));
      if (r.success) {
        _id = idX;
        setState(() {
          apiToView!(r.body);
        });
      } else {
        bool noInternet =
            MahasService.isInternetCausedError(r.message.toString());
        if (!noInternet) {
          String errorMessage;
          if (r.message.toString().startsWith("{")) {
            var errorBody = jsonDecode(r.message!);
            errorMessage = errorBody["errorMessages"][0];
          } else {
            errorMessage = r.message ?? "";
          }
          Helper.errorToast(message: errorMessage);
        } else {
          Helper.errorToast();
        }
      }
    } else {
      setState(() {
        apiToView!(idX);
      });
    }
  }

  void _back() {
    Helper.backOnPress(
      result: _backRefresh,
      editable: editable,
      questionBack: withQuestionBack,
      parametes: pageBackParametes,
    );
  }

  Future<bool> _onWillPop() async {
    if (useThisBackAction) {
      _back();
    }
    return false;
  }

  void _popupMenuButtonOnSelected(String v) async {
    if (v == 'Edit') {
      editable = true;
      setState(() {});
    } else if (v == 'Cancel') {
      _init();
      editable = false;
      setState(() {});
    } else if (v == 'Delete') {
      final r = await Helper.dialogConfirmation(
        message: 'Yakin akan menghapus data ini?',
        textConfirm: 'Hapus',
      );

      if (r == true) {
        await MahasService.loadingOverlay(false);
        final r = await HttpApi.delete(urlApiDelete!(_id));
        await EasyLoading.dismiss();
        if (r.success) {
          _backRefresh = true;
          _back();
        } else {
          Helper.dialogWarning(r.message!);
        }
      }
    }
  }

  void submitOnPressed() async {
    if (onSubmit != null) {
      onSubmit!();
    } else {
      if (EasyLoading.isShow) return;
      if (onBeforeSubmit != null) {
        if (!onBeforeSubmit!()) return;
      }
      final model = bodyApi != null ? bodyApi!(_id) : null;

      if (urlApiPost != null || urlApiPut != null) {
        await MahasService.loadingOverlay(false);
        setState(() {
          editable = false;
        });
        ApiResultModel r = _id == null
            ? await HttpApi.post(
                urlApiPost!(),
                body: model,
                contentType: contentType,
              )
            : await HttpApi.put(
                urlApiPut!(_id),
                body: model,
              );
        if (r.success) {
          if (autoBack && _id == null) {
            Get.back();
          }
          if (onSuccessSubmit != null) {
            onSuccessSubmit!(r);
          } else {
            editable = false;
            _backRefresh = true;
            _id ??= itemIdAfterSubmit(r.body);
            if (!autoBack) await _getModelFromApi(_id);
          }
        } else {
          bool noInternet =
              MahasService.isInternetCausedError(r.errorMessages.toString());
          if (!noInternet) {
            String errorMessage;
            if (r.message.toString().startsWith("{")) {
              var errorBody = jsonDecode(r.message!);
              errorMessage = errorBody["errorMessages"][0];
            } else {
              errorMessage = r.message ?? "";
            }
            Helper.errorToast(message: errorMessage);
          } else {
            Helper.errorToast();
          }
          setState(() {
            editable = true;
          });
        }
        await EasyLoading.dismiss();
      }
    }
  }

  SetupPageState get isState {
    if (editable) {
      if (_id == null) {
        return SetupPageState.create;
      } else {
        return SetupPageState.update;
      }
    } else {
      return SetupPageState.detail;
    }
  }
}

class SetupPageComponent extends StatefulWidget {
  final SetupPageController controller;
  final bool childrenPadding;
  final String title;
  final Function children;
  final bool showAppBar;
  final bool withScaffold;
  final dynamic crossAxisAlignmentChildren;
  final Function? titleFunction;
  final List<Widget>? childrenAfterButton;
  final String? customBackground;
  final bool useCardInside;
  final String btnSubmitText;
  final String? headerLogo;
  final String? headerText;
  final double buttonRadius;

  const SetupPageComponent({
    super.key,
    required this.title,
    required this.controller,
    this.childrenPadding = true,
    this.useCardInside = false,
    this.customBackground,
    required this.children,
    this.childrenAfterButton,
    this.crossAxisAlignmentChildren = CrossAxisAlignment.center,
    this.titleFunction,
    this.btnSubmitText = "Simpan",
    this.headerLogo,
    this.headerText,
    this.showAppBar = true,
    this.withScaffold = true,
    this.buttonRadius = 10,
  });

  @override
  State<SetupPageComponent> createState() => _SetupPageComponentState();
}

class _SetupPageComponentState extends State<SetupPageComponent> {
  @override
  void initState() {
    widget.controller._init(
        setStateX: (fn) {
          if (mounted) {
            setState(fn);
          }
        },
        contextX: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.controller._onWillPop,
      child: !widget.withScaffold
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: widget.crossAxisAlignmentChildren,
                  children: widget.children(),
                ),
                Visibility(
                  visible: widget.controller.editable,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: widget.childrenPadding ? 20 : 0,
                      horizontal: widget.childrenPadding ? 10 : 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ButtonComponent(
                        onTap: widget.controller.submitOnPressed,
                        text: widget.btnSubmitText,
                        fontSize: MahasFontSize.h6,
                        fontWeight: FontWeight.w600,
                        textColor: MahasColors.light,
                        btnColor: MahasColors.primary,
                        width: (Get.width * 0.5) - 30,
                        borderColor: MahasColors.light,
                        borderRadius: MahasThemes.borderRadius / 2,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.childrenAfterButton != null,
                  child: Column(
                    children: widget.childrenAfterButton ?? [],
                  ),
                ),
              ],
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              appBar: !widget.showAppBar
                  ? null
                  : MahasWidget.mahasAppBar(
                      title: widget.title,
                      onBackTap: widget.controller._onWillPop,
                      elevation: 0,
                      actionBtn: widget.controller._id == null ||
                              (!widget.controller.allowEdit &&
                                  !widget.controller.allowDelete)
                          ? []
                          : [
                              PopupMenuButton(
                                onSelected: widget
                                    .controller._popupMenuButtonOnSelected,
                                itemBuilder: (BuildContext context) {
                                  List<PopupMenuItem<String>> r = [];
                                  if (widget.controller.editable) {
                                    r.add(const PopupMenuItem(
                                      value: 'Cancel',
                                      child: Text('Batal'),
                                    ));
                                  } else {
                                    if (widget.controller.allowEdit) {
                                      r.add(const PopupMenuItem(
                                        value: 'Edit',
                                        child: Text('Edit'),
                                      ));
                                    }
                                    if (widget.controller.allowDelete) {
                                      r.add(const PopupMenuItem(
                                        value: 'Delete',
                                        child: Text('Delete'),
                                      ));
                                    }
                                  }
                                  return r;
                                },
                              ),
                            ],
                    ),
              body: Stack(
                children: [
                  widget.customBackground == null
                      ? MahasWidget.hideWidget()
                      : ImageComponent(
                          width: Get.width,
                          svgUrl: widget.customBackground,
                          boxFit: BoxFit.fitWidth,
                        ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        widget.headerLogo != null
                            ? ImageComponent(
                                margin: const EdgeInsets.only(top: 20),
                                localUrl: widget.headerLogo,
                                width: 100,
                                height: 100,
                              )
                            : MahasWidget.hideWidget(),
                        widget.headerText != null
                            ? TextComponent(
                                margin: const EdgeInsets.only(top: 10),
                                value: widget.headerText,
                                fontSize: MahasFontSize.h3,
                                fontWeight: FontWeight.bold,
                                fontColor: MahasColors.light,
                              )
                            : MahasWidget.hideWidget(),
                        Container(
                          padding: widget.useCardInside
                              ? const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                )
                              : null,
                          margin: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: widget.childrenPadding ? 12 : 0,
                          ),
                          decoration: widget.useCardInside
                              ? BoxDecoration(
                                  color: MahasColors.light,
                                  borderRadius: BorderRadius.circular(4),
                                )
                              : null,
                          child: widget.controller._isLoading
                              ? const ShimmerComponent()
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            widget.crossAxisAlignmentChildren,
                                        children: widget.children(),
                                      ),
                                      Visibility(
                                        visible: widget.controller.editable,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal:
                                                  !widget.childrenPadding
                                                      ? 10
                                                      : 0),
                                          child: ElevatedButton(
                                            onPressed: widget
                                                .controller.submitOnPressed,
                                            child: TextComponent(
                                              value: widget.btnSubmitText,
                                              fontWeight: FontWeight.w500,
                                              fontColor: MahasColors.light,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            widget.childrenAfterButton != null,
                                        child: Column(
                                          children:
                                              widget.childrenAfterButton ?? [],
                                        ),
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
    );
  }
}
