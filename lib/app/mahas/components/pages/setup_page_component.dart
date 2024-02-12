import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import 'package:store_cashier/app/mahas/components/mahas_themes.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../mahas_widget.dart';
import '../../services/helper.dart';
import '../images/image_component.dart';
import '../others/shimmer_component.dart';
import '../texts/text_component.dart';

enum SetupPageState {
  create,
  update,
  detail,
}

class SetupPageController<T> extends ChangeNotifier {
  final DocumentReference<T>? urlApiGet;
  final CollectionReference<T>? urlApiPost;
  final DocumentReference<T>? urlApiPut;
  final DocumentReference<T>? urlApiDelete;
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
      try {
        final r = await urlApiGet!.get();
        if (r.exists) {
          _id = idX;
          setState(() {
            apiToView!(r.data());
          });
        }
      } on FirebaseException catch (e) {
        setState(() {
          editable = true;
        });
        Helper.errorToast(message: e.message);
      } catch (e) {
        setState(() {
          editable = true;
        });
        Helper.errorToast(message: e.toString());
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
      final r = await Helper.dialogQuestion(
        message: 'Yakin akan menghapus data ini?',
        textConfirm: 'Hapus',
      );

      if (r == true) {
        await MahasService.loadingOverlay(false);
        try {
          await urlApiDelete!.delete();
          await EasyLoading.dismiss();

          _backRefresh = true;
          _back();
        } on FirebaseException catch (e) {
          await EasyLoading.dismiss();
          setState(() {
            editable = true;
          });
          Helper.errorToast(message: e.message);
        } catch (e) {
          await EasyLoading.dismiss();
          setState(() {
            editable = true;
          });
          Helper.errorToast(message: e.toString());
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
        try {
          _id == null
              ? await urlApiPost!.add(model)
              : await urlApiPut!.set(model);
          editable = false;
          _backRefresh = true;
          if (!autoBack) await _getModelFromApi(_id);
        } on FirebaseException catch (e) {
          setState(() {
            editable = true;
          });
          Helper.errorToast(message: e.message);
        } catch (e) {
          setState(() {
            editable = true;
          });
          Helper.errorToast(message: e.toString());
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
  final String? title;
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
    this.title,
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
                MahasWidget.uniformCardWidget(
                  child: Column(
                    crossAxisAlignment: widget.crossAxisAlignmentChildren,
                    children: widget.children(),
                  ),
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
                        // width: (Get.width * 0.5) - 30,
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
                      title: widget.title ?? "",
                      onBackTap: widget.controller._onWillPop,
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
              body: MahasWidget.safeAreaWidget(
                child: Stack(
                  children: [
                    MahasWidget.backgroundWidget(),
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
                          widget.controller._isLoading
                              ? const ShimmerComponent(
                                  isCardList: false,
                                  marginLeft: 10,
                                  marginRight: 10,
                                  marginTop: 0,
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      MahasWidget.uniformCardWidget(
                                        child: Column(
                                          crossAxisAlignment:
                                              widget.crossAxisAlignmentChildren,
                                          children: widget.children(),
                                        ),
                                      ),
                                      Visibility(
                                        visible: widget.controller.editable,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                widget.childrenPadding ? 20 : 0,
                                            horizontal:
                                                widget.childrenPadding ? 10 : 0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: ButtonComponent(
                                              onTap: widget
                                                  .controller.submitOnPressed,
                                              text: widget.btnSubmitText,
                                              fontSize: MahasFontSize.h6,
                                              fontWeight: FontWeight.w600,
                                              textColor: MahasColors.light,
                                              btnColor: MahasColors.primary,
                                              borderColor: MahasColors.light,
                                              borderRadius:
                                                  MahasThemes.borderRadius / 2,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
