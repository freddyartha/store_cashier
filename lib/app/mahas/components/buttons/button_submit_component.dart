import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_cashier/app/mahas/components/buttons/button_component.dart';
import '../../mahas_colors.dart';
import '../../mahas_font_size.dart';
import '../../mahas_service.dart';
import '../../mahas_widget.dart';
import '../../models/api_result_model.dart';
import '../../services/http_api.dart';
import '../mahas_themes.dart';

enum SetupPageState {
  create,
  update,
  detail,
}

class ButtonSubmitController<T> extends ChangeNotifier {
  final String Function(dynamic id)? urlApiGet;
  final String Function()? urlApiPost;
  final String Function(dynamic id)? urlApiPut;
  final String Function(dynamic id)? urlApiDelete;
  bool Function()? onBeforeSubmit;
  late Function(VoidCallback fn) setState;

  String contentType;
  final bool isFormData;
  bool editable = true;

  dynamic itemId;

  dynamic model;
  Function(dynamic id)? bodyApi;
  Function(dynamic json)? apiToView;
  Function()? apiToViewError;
  BuildContext? context;

  ButtonSubmitController({
    required this.itemId,
    this.urlApiGet,
    this.urlApiPost,
    this.urlApiPut,
    this.urlApiDelete,
    this.contentType = "application/json",
    this.bodyApi,
    this.isFormData = false,
    this.apiToView,
    this.apiToViewError,
    this.onBeforeSubmit,
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
  }

  Future _getModelFromApi(dynamic idX) async {
    if (urlApiGet != null) {
      final r = await HttpApi.get(urlApiGet!(idX));
      if (r.success) {
        itemId = idX;
        setState(() => apiToView!(r.body));
        setState(() => editable = false);
      } else {
        bool error = HttpApi.httpErrorCheck(r);
        if (error) {
          setState(
            () => apiToViewError,
          );
        }
        setState(() => editable = true);
      }
    } else {
      setState(() {
        apiToView!(idX);
      });
    }
  }

  void submitOnPressed() async {
    if (onBeforeSubmit != null) {
      if (!onBeforeSubmit!()) return;
    }
    final model = bodyApi != null ? bodyApi!(itemId) : null;
    if (urlApiPost != null || urlApiPut != null) {
      await MahasService.loadingOverlay(false);
      setState(() => editable = false);
      ApiResultModel r = itemId == null
          ? await HttpApi.post(
              urlApiPost!(),
              body: model,
              contentType: contentType,
            )
          : await HttpApi.put(
              urlApiPut!(itemId),
              body: model,
            );
      if (r.success) {
        setState(() => editable = false);
        await _getModelFromApi(itemId);
      } else {
        HttpApi.httpErrorCheck(r);
        editable = true;
        setState(() => editable);
      }
      await EasyLoading.dismiss();
    }
  }
}

class ButtonSubmitComponent extends StatefulWidget {
  final ButtonSubmitController controller;
  final String btnSubmitText;
  final double horizontalPadding;
  final bool isElevated;
  final Function children;
  final dynamic crossAxisAlignmentChildren;

  const ButtonSubmitComponent({
    super.key,
    required this.controller,
    this.btnSubmitText = "Simpan",
    this.horizontalPadding = 10,
    this.isElevated = true,
    required this.children,
    this.crossAxisAlignmentChildren = CrossAxisAlignment.start,
  });

  @override
  State<ButtonSubmitComponent> createState() => _ButtonSubmitComponentState();
}

class _ButtonSubmitComponentState extends State<ButtonSubmitComponent> {
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
    return Column(
      children: [
        Column(
          crossAxisAlignment: widget.crossAxisAlignmentChildren,
          children: widget.children(),
        ),
        Visibility(
          visible: widget.controller.editable,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 15,
              left: widget.horizontalPadding,
              right: widget.horizontalPadding,
            ),
            child: MahasWidget.uniformCardWidget(
              color: MahasColors.primary,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: ButtonComponent(
                onTap: widget.controller.submitOnPressed,
                text: widget.btnSubmitText,
                btnColor: MahasColors.primary,
                borderColor: MahasColors.light,
                borderRadius: MahasThemes.borderRadius,
                fontSize: MahasFontSize.h6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
