import 'dart:convert';

class UnitprodukModel {
  String? unit;
  String? keterangan;

  UnitprodukModel();
  UnitprodukModel.init(this.unit, this.keterangan);

  static UnitprodukModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UnitprodukModel fromDynamic(dynamic dynamicData) {
    final model = UnitprodukModel();

    model.unit = dynamicData['unit'];
    model.keterangan = dynamicData['keterangan'];

    return model;
  }

  static Map<String, dynamic> toJSon(UnitprodukModel data) {
    var mapData = {
      'unit': data.unit,
      'keterangan': data.keterangan,
    };
    return mapData;
  }
}
