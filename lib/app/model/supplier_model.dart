import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  String? kodeSupplier;
  String? namaSupplier;
  String? namaSupplierLowercase;
  String? kontakSupplier;
  String? emailSupplier;
  String? alamatSupplier;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;
  String? updatedBy;

  SupplierModel();
  static SupplierModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static SupplierModel fromDynamic(dynamic dynamicData) {
    final model = SupplierModel();

    model.kodeSupplier = dynamicData['kode_supplier'];
    model.namaSupplier = dynamicData['nama_supplier'];
    model.namaSupplierLowercase = dynamicData['nama_supplier_lowercase'];
    model.kontakSupplier = dynamicData['kontak_supplier'];
    model.emailSupplier = dynamicData['email_supplier'];
    model.alamatSupplier = dynamicData['alamat_supplier'];
    model.createdAt = dynamicData['createdAt'];
    model.createdBy = dynamicData['createdBy'];
    model.updatedAt = dynamicData['updatedAt'];
    model.updatedBy = dynamicData['updatedBy'];

    return model;
  }

  static Map<String, dynamic> toJSon(SupplierModel data) {
    var mapData = {
      'kode_supplier': data.kodeSupplier,
      'nama_supplier': data.namaSupplier,
      'nama_supplier_lowercase': data.namaSupplierLowercase,
      'kontak_supplier': data.kontakSupplier,
      'email_supplier': data.emailSupplier,
      'alamat_supplier': data.alamatSupplier,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy,
    };
    return mapData;
  }
}
