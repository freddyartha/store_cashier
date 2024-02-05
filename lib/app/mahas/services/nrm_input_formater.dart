import 'package:flutter/services.dart';

class NRMInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String value = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      int index = i + 1;
      if (index % 2 == 0 && value.length != index) {
        buffer.write(".");
      }
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}
