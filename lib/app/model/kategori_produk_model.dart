import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriprodukModel {
  String? kategori;
  String? kategoriLowercase;
  String? keterangan;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;
  String? updatedBy;

  KategoriprodukModel();

  static KategoriprodukModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static KategoriprodukModel fromDynamic(dynamic dynamicData) {
    final model = KategoriprodukModel();

    model.kategori = dynamicData['kategori'];
    model.kategoriLowercase = dynamicData['kategori_lowercase'];
    model.keterangan = dynamicData['keterangan'];
    model.createdAt = dynamicData['createdAt'];
    model.createdBy = dynamicData['createdBy'];
    model.updatedAt = dynamicData['updatedAt'];
    model.updatedBy = dynamicData['updatedBy'];

    return model;
  }

  static Map<String, dynamic> toJSon(KategoriprodukModel data) {
    var mapData = {
      'kategori': data.kategori,
      'kategori_lowercase': data.kategoriLowercase,
      'keterangan': data.keterangan,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy,
    };
    return mapData;
  }
}
