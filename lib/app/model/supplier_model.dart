import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  String? kodesupplier;
  String? namasupplier;
  String? namasupplierlowercase;
  String? kontaksupplier;
  String? emailsupplier;
  String? alamatsupplier;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  SupplierModel();
  static SupplierModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static SupplierModel fromDynamic(dynamic dynamicData) {
    final model = SupplierModel();

    model.kodesupplier = dynamicData['kodeSupplier'];
    model.namasupplier = dynamicData['namaSupplier'];
    model.namasupplierlowercase = dynamicData['namaSupplierLowerCase'];
    model.kontaksupplier = dynamicData['kontakSupplier'];
    model.emailsupplier = dynamicData['emailSupplier'];
    model.alamatsupplier = dynamicData['alamatSupplier'];
    model.createdAt = dynamicData['createdAt'];
    model.updatedAt = dynamicData['updatedAt'];

    return model;
  }

  static Map<String, dynamic> toJSon(SupplierModel data) {
    var mapData = {
      'kodeSupplier': data.kodesupplier,
      'namaSupplier': data.namasupplier,
      'namaSupplierLowerCase': data.namasupplierlowercase,
      'kontakSupplier': data.kontaksupplier,
      'emailSupplier': data.emailsupplier,
      'alamatSupplier': data.alamatsupplier,
      'createdAt': data.createdAt,
      'updatedAt': data.updatedAt,
    };
    return mapData;
  }
}
