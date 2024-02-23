import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_cashier/app/mahas/services/mahas_format.dart';

class CustomerModel {
  String? namaCustomer;
  int? tipeCustomer;
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
    model.tipeCustomer = MahasFormat.dynamicToInt('tipe_customer');
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
      'tipe_customer': data.tipeCustomer,
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
