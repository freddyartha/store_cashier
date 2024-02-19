import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../mahas/services/mahas_format.dart';

class ProdukModel {
  String? kodeproduk;
  String? namaproduk;
  String? namaproduklowercase;
  String? unitid;
  String? kategoriid;
  double? stokproduk;
  double? hargaproduk;
  double? diskonpersen;
  double? reorderlevel;
  List<String>? fotoProduk;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;
  String? updatedBy;

  ProdukModel();

  static ProdukModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ProdukModel fromDynamic(dynamic dynamicData) {
    final model = ProdukModel();

    model.kodeproduk = dynamicData['kodeProduk'];
    model.namaproduk = dynamicData['namaProduk'];
    model.namaproduklowercase = dynamicData['namaProdukLowerCase'];
    model.unitid = dynamicData['unitId'];
    model.kategoriid = dynamicData['kategoriId'];
    model.stokproduk = MahasFormat.dynamicToDouble(dynamicData['stokProduk']);
    model.hargaproduk = MahasFormat.dynamicToDouble(dynamicData['hargaProduk']);
    model.diskonpersen =
        MahasFormat.dynamicToDouble(dynamicData['diskonPersen']);
    model.reorderlevel =
        MahasFormat.dynamicToDouble(dynamicData['reorderLevel']);
    model.fotoProduk =
        List<String>.from(dynamicData['fotoProduk'].map((x) => x));
    model.createdAt = dynamicData['createdAt'];
    model.createdBy = dynamicData['createdBy'];
    model.updatedAt = dynamicData['updatedAt'];
    model.updatedBy = dynamicData['updatedBy'];

    return model;
  }

  static Map<String, dynamic> toJSon(ProdukModel data) {
    var mapData = {
      'kodeProduk': data.kodeproduk,
      'namaProduk': data.namaproduk,
      'namaProdukLowerCase': data.namaproduklowercase,
      'unitId': data.unitid,
      'kategoriId': data.kategoriid,
      'stokProduk': data.stokproduk,
      'hargaProduk': data.hargaproduk,
      'diskonPersen': data.diskonpersen,
      'reorderLevel': data.reorderlevel,
      'fotoProduk': data.fotoProduk,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy,
    };
    return mapData;
  }
}
