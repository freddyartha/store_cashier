import 'dart:convert';

class CompanyModel {
  String? namaPerusahaan;
  String? alamatPerusahaan;
  List<dynamic>? userId;

  CompanyModel();
  CompanyModel.init({
    this.namaPerusahaan,
    this.alamatPerusahaan,
    this.userId,
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

    return model;
  }

  static Map<String, dynamic> toJSon(CompanyModel data) {
    var mapData = {
      'nama_perusahaan': data.namaPerusahaan,
      'alamat_perusahaan': data.alamatPerusahaan,
      'user_id': data.userId,
    };
    return mapData;
  }
}
