import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../mahas_colors.dart';
import '../../services/mahas_format.dart';
import '../../services/nrm_input_formater.dart';
import 'input_box_component.dart';

enum InputTextType {
  text,
  email,
  password,
  number,
  paragraf,
  money,
  phone,
  ktp,
  name,
  nrm
}

class InputTextController extends ChangeNotifier {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _con = TextEditingController();
  Function(VoidCallback fn)? setState;

  InputTextController({
    this.type = InputTextType.text,
  });

  bool _required = false;
  InputTextType type = InputTextType.text;
  double? _moneyValue;
  bool _showPassword = false;

  ValueChanged<String>? onChanged;
  FormFieldSetter<String>? onSaved;
  VoidCallback? onEditingComplete;

  FocusNode focusNode = FocusNode();
  BuildContext? _context;
  int? _numberOfPhoneNumberLength;
  GestureTapCallback? onTap;

  String? _validator(String v, {FormFieldValidator<String>? otherValidator}) {
    if (_required && (v.isEmpty)) {
      return 'Kolom harus diisi';
    }
    if (type == InputTextType.email) {
      final regex = RegExp(
          r'''^(?!.*[._]{2})[a-zA-Z0-9._]+@[a-zA-Z.]+\.[a-zA-Z]{2,}(?:[a-zA-Z0-9-]{0,61}[a-zA-Z])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$''');
      if ((v.isEmpty) ||
          !regex.hasMatch(v) ||
          !RegExp(r"^[a-zA-Z]").hasMatch(value)) {
        return 'Alamat email tidak valid';
      } else {
        return null;
      }
    }
    if (type == InputTextType.phone) {
      if (v.length < _numberOfPhoneNumberLength! && v.isNotEmpty) {
        return 'Minimal ${_numberOfPhoneNumberLength.toString()} digit';
      }
    }

    if (type == InputTextType.ktp) {
      if (v.length < 16) return "Tambahkan min. 16 digits";
    }
    if (otherValidator != null) {
      return otherValidator(v);
    }
    return null;
  }

  void _onFocusChange(bool stateFocus) {
    if (stateFocus) {
      _con.text = _moneyValue == 0 ? "" : "${_moneyValue ?? ""}";
    } else {
      _moneyValue = double.tryParse(_con.text);
      _con.text =
          MahasFormat().mataUangID(_moneyValue ?? 0).replaceAll(" ", "");
    }
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
  }

  ValueChanged<String> validateOnChange() {
    return onChanged = (value) {
      if (isValid) {
        setState;
      }
    };
  }

  bool get isValid {
    bool? valid = _key.currentState?.validate();
    if (valid == null) {
      return true;
    }
    if (valid == false) {
      FocusScope.of(_context!).requestFocus(focusNode);
    }
    return valid;
  }

  dynamic get value {
    if (type == InputTextType.number) {
      return num.tryParse(_con.text);
    } else if (type == InputTextType.money) {
      return _moneyValue;
    } else {
      return _con.text;
    }
  }

  void clearFocus() {
    if (focusNode.hasPrimaryFocus) {
      focusNode.unfocus();
    }
  }

  void clearValue() {
    _con.clear();
  }

  set value(dynamic value) {
    if (type == InputTextType.money) {
      _con.text = value == null
          ? ""
          : MahasFormat().mataUangID(value ?? 0).replaceAll(" ", "");
      _moneyValue = value;
    } else {
      _con.text = value == null ? "" : "$value";
    }
  }

  @override
  void dispose() {
    _con.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class InputTextComponent extends StatefulWidget {
  final bool isRequired;
  final String? label;
  final TextStyle? labelStyle;
  final bool editable;
  final String? placeHolder;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final Radius? borderRadius;
  final bool visibility;
  final EdgeInsets edgeInsets;
  final InputTextController? controller;
  // final Function()? onEditingComplete;
  final Function(String)? onFieldSubmited;
  final double fontsize;
  final FontWeight? fontWeight;
  final Color fontColor;
  final int? maxLength;
  final Color hintColor;
  final Color? fillColor;
  final double errorTextSize;
  final int maxDigitPhoneNumber;
  final InputDecoration? customInputDecoration;
  final String? prefixText;
  final BoxConstraints? prefixValueConstraints;
  final Widget? prefixValueWidget;
  final bool showSuffixBesidePassword;
  final Widget? suffixValueWidget;
  final bool hasBorder;
  final bool isBorderRectangle;
  final bool setLabelPaddingLeft;
  final double? marginBottom;
  const InputTextComponent(
      {super.key,
      @required this.controller,
      this.isRequired = false,
      this.label,
      this.labelStyle,
      this.editable = true,
      this.placeHolder,
      this.inputFormatters,
      this.validator,
      // this.onEditingComplete,
      this.maxLength,
      this.maxDigitPhoneNumber = 10,
      this.borderRadius,
      this.fontsize = 13,
      this.fontColor = Colors.black,
      this.fontWeight,
      this.onFieldSubmited,
      this.edgeInsets = const EdgeInsets.all(0),
      this.visibility = true,
      this.fillColor,
      this.customInputDecoration,
      this.prefixText,
      this.prefixValueConstraints,
      this.prefixValueWidget,
      this.showSuffixBesidePassword = false,
      this.suffixValueWidget,
      this.hintColor = MahasColors.grey,
      this.hasBorder = true,
      this.isBorderRectangle = false,
      this.setLabelPaddingLeft = true,
      this.errorTextSize = 10,
      this.marginBottom});

  @override
  State<InputTextComponent> createState() => _InputTextComponentState();
}

class _InputTextComponentState extends State<InputTextComponent> {
  @override
  void initState() {
    widget.controller!._init(setState);
    widget.controller!.validateOnChange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller!._required = widget.isRequired;
    widget.controller!._context = context;
    widget.controller!._numberOfPhoneNumberLength = widget.maxDigitPhoneNumber;

    final decoration = InputDecoration(
      filled: true,
      fillColor: widget.fillColor ??
          Colors.black.withOpacity(widget.editable ? .01 : .07),
      hintText: widget.placeHolder,
      errorStyle: TextStyle(fontSize: widget.errorTextSize, height: 0.3),
      isDense: true,
      focusedErrorBorder: widget.isBorderRectangle
          ? OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(.5)),
              borderRadius: BorderRadius.all(
                  widget.borderRadius ?? const Radius.circular(4.0)),
            )
          : UnderlineInputBorder(
              borderSide: widget.hasBorder
                  ? BorderSide(color: Colors.grey[200]!)
                  : BorderSide.none,
            ),
      focusedBorder: widget.isBorderRectangle
          ? OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black.withOpacity(widget.editable ? .1 : .3)),
              borderRadius: BorderRadius.all(
                  widget.borderRadius ?? const Radius.circular(4.0)),
            )
          : UnderlineInputBorder(
              borderSide: widget.hasBorder
                  ? BorderSide(color: Colors.grey[200]!)
                  : BorderSide.none,
            ),
      enabledBorder: widget.isBorderRectangle
          ? OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black.withOpacity(widget.editable ? .1 : .3)),
              borderRadius: BorderRadius.all(
                  widget.borderRadius ?? const Radius.circular(4.0)),
            )
          : UnderlineInputBorder(
              borderSide: widget.hasBorder
                  ? BorderSide(color: Colors.grey[200]!)
                  : BorderSide.none,
            ),
      prefixText: widget.prefixText,
      prefixStyle: TextStyle(
        color: Colors.black.withOpacity(0.6),
      ),
      prefixIconConstraints: widget.prefixValueConstraints ??
          const BoxConstraints(
            minHeight: 16,
            minWidth: 16,
          ),
      prefixIcon: widget.prefixValueWidget,
      suffixIconConstraints: const BoxConstraints(
        minHeight: 30,
        minWidth: 30,
      ),
      suffixIcon: widget.showSuffixBesidePassword
          ? widget.suffixValueWidget
          : widget.controller!.type == InputTextType.password
              ? InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => setState(() {
                    widget.controller!._showPassword =
                        !widget.controller!._showPassword;
                  }),
                  child: Icon(
                    widget.controller!._showPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black.withOpacity(0.6),
                    size: 14,
                  ),
                )
              : null,
    );

    var textFormField = TextFormField(
      maxLines: widget.controller!.type == InputTextType.paragraf ? 4 : 1,
      maxLength: (widget.controller!.type == InputTextType.ktp)
          ? 16
          : ((widget.controller!.type == InputTextType.phone) ||
                  widget.controller!.type == InputTextType.text ||
                  widget.controller!.type == InputTextType.email ||
                  widget.controller!.type == InputTextType.name)
              ? widget.maxLength
              : null,
      onChanged: widget.controller!.onChanged,
      onSaved: widget.controller!.onSaved,
      onTap: widget.controller!.onTap,
      focusNode: widget.controller!.focusNode,
      onFieldSubmitted: widget.onFieldSubmited,
      style: TextStyle(
        color: widget.fontColor,
        fontSize: widget.fontsize,
        fontWeight: widget.fontWeight ?? FontWeight.normal,
      ),
      inputFormatters: (widget.controller!.type == InputTextType.number ||
              widget.controller!.type == InputTextType.money ||
              widget.controller!.type == InputTextType.ktp)
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,10}')),
              ...(widget.inputFormatters ?? []),
            ]
          : widget.controller!.type == InputTextType.name
              ? [
                  FilteringTextInputFormatter.allow(
                      RegExp(r"^[A-Za-z ,.\'-]+")),
                ]
              : widget.controller!.type == InputTextType.phone
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\d{0,10}')),
                    ]
                  : widget.controller!.type == InputTextType.nrm
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          NRMInputFormatter(),
                          LengthLimitingTextInputFormatter(8),
                          ...(widget.inputFormatters ?? []),
                        ]
                      : null,
      controller: widget.controller!._con,
      validator: (v) =>
          widget.controller!._validator(v!, otherValidator: widget.validator),
      autocorrect: false,
      enableSuggestions: false,
      readOnly: !widget.editable,
      obscureText: widget.controller!.type == InputTextType.password
          ? !widget.controller!._showPassword
          : false,
      onEditingComplete: widget.controller!.onEditingComplete,
      keyboardType: (widget.controller!.type == InputTextType.number ||
              widget.controller!.type == InputTextType.money ||
              widget.controller!.type == InputTextType.phone ||
              widget.controller!.type == InputTextType.ktp ||
              widget.controller!.type == InputTextType.nrm)
          ? TextInputType.number
          : null,
      decoration: widget.customInputDecoration ?? decoration,
    );

    return Visibility(
      visible: widget.visibility,
      child: Container(
        margin: widget.edgeInsets,
        child: InputBoxComponent(
          marginBottom: widget.marginBottom,
          label: widget.label,
          labelStyle: widget.labelStyle,
          childText: widget.controller!._con.text,
          isRequired: widget.isRequired,
          children: Row(
            children: [
              Flexible(
                child: Form(
                  key: widget.controller!._key,
                  child: widget.controller!.type == InputTextType.money
                      ? Focus(
                          onFocusChange: widget.controller!._onFocusChange,
                          child: textFormField,
                        )
                      : textFormField,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
