import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? kodeCustomer;
  String? namaCustomer;
  String? namaCustomerLowercase;
  String? kontakCustomer;
  String? alamatCustomer;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;
  String? updatedBy;

  CustomerModel();

  static CustomerModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static CustomerModel fromDynamic(dynamic dynamicData) {
    final model = CustomerModel();

    model.kodeCustomer = dynamicData['kode_customer'];
    model.namaCustomer = dynamicData['nama_customer'];
    model.namaCustomerLowercase = dynamicData['nama_customer_lowercase'];
    model.kontakCustomer = dynamicData['kontak_customer'];
    model.alamatCustomer = dynamicData['alamat_customer'];
    model.createdAt = dynamicData['createdAt'];
    model.createdBy = dynamicData['createdBy'];
    model.updatedAt = dynamicData['updatedAt'];
    model.updatedBy = dynamicData['updatedBy'];

    return model;
  }

  static Map<String, dynamic> toJSon(CustomerModel data) {
    var mapData = {
      'kode_customer': data.kodeCustomer,
      'nama_customer': data.namaCustomer,
      'nama_customer_lowercase': data.namaCustomerLowercase,
      'kontak_customer': data.kontakCustomer,
      'alamat_customer': data.alamatCustomer,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy,
    };
    return mapData;
  }
}
