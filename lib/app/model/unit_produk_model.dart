import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UnitprodukModel {
  String? unit;
  String? unitLowerCase;
  String? keterangan;
  Timestamp? createdAt;
  Timestamp? updatedAt;

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
    model.createdAt = dynamicData['createdAt'];

    return model;
  }

  static Map<String, dynamic> toJSon(UnitprodukModel data) {
    var mapData = {
      'unit': data.unit,
      'unitLowerCase': data.unitLowerCase,
      'keterangan': data.keterangan,
      'createdAt': data.createdAt,
      'updatedAt': data.updatedAt,
    };
    return mapData;
  }
}
