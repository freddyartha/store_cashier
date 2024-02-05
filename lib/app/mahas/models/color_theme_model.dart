import 'dart:convert';

class ColorThemeModel {
  String? primary;
  String? danger;
  String? warning;

  ColorThemeModel();

  static ColorThemeModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ColorThemeModel fromDynamic(dynamic dynamicData) {
    final model = ColorThemeModel();

    model.primary = dynamicData['primary'];
    model.danger = dynamicData['danger'];
    model.warning = dynamicData['warning'];

    return model;
  }
}
