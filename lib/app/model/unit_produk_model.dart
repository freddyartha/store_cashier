import 'dart:convert';

class UnitprodukModel {
  String? unit;
  String? unitLowerCase;
  String? keterangan;

  UnitprodukModel();

  static UnitprodukModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UnitprodukModel fromDynamic(dynamic dynamicData) {
    final model = UnitprodukModel();

    model.unit = dynamicData['unit'];
    model.unitLowerCase = dynamicData['unitLowerCase'];
    model.keterangan = dynamicData['keterangan'];

    return model;
  }

  static Map<String, dynamic> toJSon(UnitprodukModel data) {
    var mapData = {
      'unit': data.unit,
      'unitLowerCase': data.unitLowerCase,
      'keterangan': data.keterangan,
    };
    return mapData;
  }
}
