import 'package:flutter/material.dart';
import '../../mahas_colors.dart';
import '../../services/helper.dart';
import '../texts/text_component.dart';
import 'input_box_component.dart';

enum CheckboxPosition { left, right }

class RadioButtonItem {
  dynamic id;
  String text;
  dynamic value;

  RadioButtonItem({
    this.id,
    required this.text,
    this.value,
  });

  RadioButtonItem.autoId(String text, dynamic value)
      : this(
          id: Helper.idGenerator,
          text: text,
          value: value,
        );

  RadioButtonItem.simple(String value) : this.autoId(value, value);
}

class InputRadioController {
  late Function(VoidCallback fn) setState;

  List<RadioButtonItem> items;
  RadioButtonItem? _value;
  Function(RadioButtonItem item)? onChanged;
  bool required = false;
  String? _errorMessage;
  bool _isInit = false;

  InputRadioController({
    this.items = const [],
    this.onChanged,
  });

  void _onChanged(RadioButtonItem v, bool editable) {
    if (!editable) return;
    setState(() {
      _value = v;
      if (onChanged != null) {
        onChanged!(v);
      }
    });
  }

  set setItems(List<RadioButtonItem> val) {
    if (val.where((e) => e.value == _value?.value).isEmpty) {
      _value = null;
    }
    items = val;
  }

  dynamic get value {
    return _value?.value;
  }

  set value(dynamic val) {
    _value = items.firstWhere((e) => e.value == val);
    if (_isInit) {
      setState(() {});
    }
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
    _isInit = true;
  }

  bool get isValid {
    setState(() {
      _errorMessage = null;
    });
    if (required && _value == null) {
      setState(() {
        _errorMessage = 'Pilih salah satu opsi';
      });
      return false;
    }
    return true;
  }
}

class InputRadioComponent extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final bool editable;
  final bool required;
  final InputRadioController controller;
  final CheckboxPosition position;
  final double? marginBottom;

  const InputRadioComponent({
    super.key,
    this.label,
    this.labelStyle,
    this.editable = true,
    this.required = false,
    required this.controller,
    this.position = CheckboxPosition.left,
    this.marginBottom,
  });

  @override
  State<InputRadioComponent> createState() => _InputRadioComponentState();
}

class _InputRadioComponentState extends State<InputRadioComponent> {
  @override
  void initState() {
    widget.controller._init((fn) {
      if (mounted) {
        setState(fn);
      }
    });
    widget.controller.required = widget.required;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InputBoxComponent(
      label: widget.label,
      labelStyle: widget.labelStyle,
      isRequired: widget.required,
      errorMessage: widget.controller._errorMessage,
      marginBottom: widget.marginBottom,
      children: Column(
        children: [
          const SizedBox(height: 4),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.controller.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final e = widget.controller.items[index];

              return InkWell(
                onTap: () => widget.controller._onChanged(e, widget.editable),
                child: Row(
                  children: [
                    Visibility(
                      visible: widget.position == CheckboxPosition.left,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Radio<RadioButtonItem>(
                          value: e,
                          activeColor: MahasColors.primary,
                          groupValue: widget.controller._value,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          onChanged: (value) {
                            widget.controller
                                ._onChanged(value!, widget.editable);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextComponent(
                        value: e.text,
                        fontSize: 13,
                        fontColor: MahasColors.dark,
                      ),
                    ),
                    Visibility(
                      visible: widget.position == CheckboxPosition.right,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Radio<RadioButtonItem>(
                          value: e,
                          activeColor: MahasColors.primary,
                          groupValue: widget.controller._value,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          onChanged: (value) {
                            widget.controller
                                ._onChanged(value!, widget.editable);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
