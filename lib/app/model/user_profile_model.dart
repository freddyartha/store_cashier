import 'dart:convert';
import '../mahas/services/mahas_format.dart';

class UserprofileModel {
  String? email;
  String? nama;
  int? noHp;
  String? alamat;
  String? companyId;

  UserprofileModel();
  UserprofileModel.init({
    this.email,
    this.nama,
    this.noHp,
    this.alamat,
    this.companyId,
  });
  static UserprofileModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UserprofileModel fromDynamic(dynamic dynamicData) {
    final model = UserprofileModel();

    model.email = dynamicData['email'];
    model.nama = dynamicData['nama'];
    model.noHp = MahasFormat.dynamicToInt(dynamicData['no_hp']);
    model.alamat = dynamicData['alamat'];
    model.companyId = dynamicData['company_id'];

    return model;
  }

  static Map<String, dynamic> toJSon(UserprofileModel data) {
    var mapData = {
      'email': data.email,
      'nama': data.nama,
      'no_hp': data.noHp,
      'alamat': data.alamat,
      'company_id': data.companyId,
    };
    return mapData;
  }
}
