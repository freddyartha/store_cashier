import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriprodukModel {
  String? kategori;
  String? kategoriLowerCase;
  String? keterangan;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  KategoriprodukModel();

  static KategoriprodukModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static KategoriprodukModel fromDynamic(dynamic dynamicData) {
    final model = KategoriprodukModel();

    model.kategori = dynamicData['kategori'];
    model.kategoriLowerCase = dynamicData['kategoriLowerCase'];
    model.keterangan = dynamicData['keterangan'];
    model.createdAt = dynamicData['createdAt'];
    model.updatedAt = dynamicData['updatedAt'];

    return model;
  }

  static Map<String, dynamic> toJSon(KategoriprodukModel data) {
    var mapData = {
      'kategori': data.kategori,
      'kategoriLowerCase': data.kategoriLowerCase,
      'keterangan': data.keterangan,
      'createdAt': data.createdAt,
      'updatedAt': data.updatedAt,
    };
    return mapData;
  }
}
