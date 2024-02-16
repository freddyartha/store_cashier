import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String? namaPerusahaan;
  String? alamatPerusahaan;
  List<dynamic>? userId;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;
  String? updatedBy;

  CompanyModel();
  CompanyModel.init({
    this.namaPerusahaan,
    this.alamatPerusahaan,
    this.userId,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });
  static CompanyModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static CompanyModel fromDynamic(dynamic dynamicData) {
    final model = CompanyModel();

    model.namaPerusahaan = dynamicData['nama_perusahaan'];
    model.alamatPerusahaan = dynamicData['alamat_perusahaan'];
    model.userId = dynamicData['user_id'];
    model.createdAt = dynamicData['createdAt'];
    model.createdBy = dynamicData['createdBy'];
    model.updatedAt = dynamicData['updatedAt'];
    model.updatedBy = dynamicData['updatedBy'];

    return model;
  }

  static Map<String, dynamic> toJSon(CompanyModel data) {
    var mapData = {
      'nama_perusahaan': data.namaPerusahaan,
      'alamat_perusahaan': data.alamatPerusahaan,
      'user_id': data.userId,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy,
    };
    return mapData;
  }
}
