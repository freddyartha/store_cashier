import 'dart:convert';

CabangModel remoteKeyConfigModelFromJson(String str) =>
    CabangModel.fromJson(json.decode(str));

class CabangModel {
  String? namacabang;
  String? urlApi;

  CabangModel();

  CabangModel.init(
    this.namacabang,
    this.urlApi,
  );

  static CabangModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static CabangModel fromDynamic(dynamic dynamicData) {
    final model = CabangModel();

    model.namacabang = dynamicData['namaCabang'];
    model.urlApi = dynamicData['urlApi'];

    return model;
  }

  Map<String, dynamic> cabangToJson(CabangModel data) {
    var mapData = {
      'namaCabang': data.namacabang,
      'urlApi': data.urlApi,
    };
    return mapData;
  }
}
