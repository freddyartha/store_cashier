import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import '../../mahas_colors.dart';
import 'input_box_component.dart';

class DropdownItem {
  String text;
  dynamic value;

  DropdownItem({
    required this.text,
    this.value,
  });

  DropdownItem.init(String? text, dynamic value)
      : this(
          text: text ?? "",
          value: value,
        );

  DropdownItem.simple(String? value) : this.init(value, value);
}

class InputDropdownController {
  GlobalKey<FormState>? _key;
  late Function(VoidCallback fn) setState;

  DropdownItem? _value;
  List<DropdownItem> items;
  Function(DropdownItem? value)? onChanged;
  bool _isInit = false;

  late bool _required = false;

  dynamic get value {
    return _value?.value;
  }

  String? get text {
    return _value?.text;
  }

  set value(dynamic val) {
    if (items.where((e) => e.value == val).isEmpty) {
      _value = null;
    } else {
      _value = items.firstWhere((e) => e.value == val);
    }
    if (_isInit) {
      setState(() {});
    }
  }

  set setItems(List<DropdownItem> val) {
    var selectedItemOld = _value;
    _value = null;
    items = val;

    if (selectedItemOld != null) {
      _value = items.firstWhereOrNull((e) => e.value == selectedItemOld.value);
    }
  }

  InputDropdownController({
    this.items = const [],
    this.onChanged,
  });

  void _rootOnChanged(e) {
    _value = e;
    if (onChanged != null) {
      onChanged!(e);
    }
    if (_isInit) {
      setState(() {});
    }
  }

  String? _validator(v) {
    if (_required && v == null) {
      return 'The field is required';
    }
    return null;
  }

  bool get isValid {
    bool? valid = _key?.currentState?.validate();
    if (valid == null) {
      return true;
    }
    return valid;
  }

  void _init(Function(VoidCallback fn) setStateX, bool requiredX) {
    setState = setStateX;
    _required = requiredX;
    _isInit = true;

    if (requiredX) {
      _key = GlobalKey<FormState>();
    }
  }
}

class InputDropdownComponent extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final double? marginBottom;
  final bool required;
  final bool editable;
  final InputDropdownController controller;
  final double? borderRadius;
  final bool hasBorder;
  final EdgeInsetsGeometry? padding;

  const InputDropdownComponent({
    super.key,
    this.label,
    this.placeholder,
    this.marginBottom,
    this.editable = true,
    required this.controller,
    this.required = false,
    this.borderRadius,
    this.hasBorder = true,
    this.padding,
  });

  @override
  State<InputDropdownComponent> createState() => _InputDropdownComponentState();
}

class _InputDropdownComponentState extends State<InputDropdownComponent> {
  @override
  void initState() {
    widget.controller._init(
      (fn) {
        if (mounted) {
          setState(fn);
        }
      },
      widget.required,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      isDense: true,
      filled: true,
      fillColor: widget.hasBorder
          ? MahasColors.dark.withOpacity(widget.editable ? .01 : .07)
          : MahasColors.backgroundColor,
      contentPadding:
          widget.padding ?? const EdgeInsets.fromLTRB(10, 12, 10, 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 4),
        ),
        borderSide: widget.hasBorder
            ? BorderSide(
                color: MahasColors.dark.withOpacity(widget.editable ? .1 : .3))
            : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 4),
        ),
        borderSide: widget.hasBorder
            ? BorderSide(
                color: MahasColors.dark.withOpacity(widget.editable ? .1 : .3))
            : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 4),
        ),
        borderSide: widget.hasBorder
            ? BorderSide(
                color: MahasColors.dark.withOpacity(widget.editable ? .1 : .3))
            : BorderSide.none,
      ),
      prefixStyle: TextStyle(
        color: MahasColors.light.withOpacity(0.6),
      ),
      suffixIconConstraints: const BoxConstraints(
        minHeight: 30,
        minWidth: 30,
      ),
    );

    final dropdownButton = DropdownButtonFormField(
      decoration: decoration,
      isExpanded: true,
      focusColor: Colors.transparent,
      validator: widget.controller._validator,
      value: widget.controller._value,
      onChanged: widget.editable ? widget.controller._rootOnChanged : null,
      hint: Text(
        widget.placeholder ?? "Select",
        style: TextStyle(
          fontSize: MahasFontSize.normal,
          color: MahasColors.dark.withOpacity(widget.editable ? .5 : .7),
        ),
      ),
      style: TextStyle(
          color: MahasColors.dark.withOpacity(.7),
          fontSize: MahasFontSize.normal),
      items: widget.controller.items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.text),
              ))
          .toList(),
    );

    return InputBoxComponent(
      label: widget.label,
      isRequired: widget.required,
      marginBottom: widget.marginBottom,
      borderRadius: widget.borderRadius ?? 4,
      childText: widget.controller._value?.text ?? "",
      children: widget.editable
          ? widget.required
              ? Form(
                  key: widget.controller._key,
                  child: dropdownButton,
                )
              : dropdownButton
          : null,
    );
  }
}
