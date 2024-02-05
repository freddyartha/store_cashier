import 'dart:convert';

import 'package:store_cashier/app/mahas/services/mahas_format.dart';

class AppFeaturesModel {
	bool cppt;
	bool cept;
	bool vitalSign;
	bool persetujuanTindakan;
	bool penolakanTindakan;
	bool telaahResep;
	bool generalConsent;
	bool uploadDokumen;
	bool dischargeSummary;
	bool visiteDokter;
	bool resumeRawatJalan;

  AppFeaturesModel(
    {
      this.cppt = false,
      this.cept = false,
      this.vitalSign = false,
      this.persetujuanTindakan = false,
      this.penolakanTindakan = false,
      this.telaahResep = false,
      this.generalConsent = false,
      this.uploadDokumen = false,
      this.dischargeSummary = false,
      this.visiteDokter = false,
      this.resumeRawatJalan = false
    }
  );

	static AppFeaturesModel fromJson(String jsonString) {
		final data = json.decode(jsonString);
		return AppFeaturesModel.fromMap(data);
	}

  factory AppFeaturesModel.fromMap(Map<String, dynamic> map) {
    return AppFeaturesModel(
    cppt : MahasFormat.dynamicToBool(map['cppt']) ?? true,
		cept : MahasFormat.dynamicToBool(map['cept']) ?? true,
		vitalSign : MahasFormat.dynamicToBool(map['vital_sign']) ?? true,
		persetujuanTindakan : MahasFormat.dynamicToBool(map['persetujuan_tindakan']) ?? true,
		penolakanTindakan : MahasFormat.dynamicToBool(map['penolakan_tindakan']) ?? true,
		telaahResep : MahasFormat.dynamicToBool(map['telaah_resep']) ?? true,
		generalConsent : MahasFormat.dynamicToBool(map['general_consent']) ?? true,
		uploadDokumen : MahasFormat.dynamicToBool(map['upload_dokumen']) ?? true,
		dischargeSummary : MahasFormat.dynamicToBool(map['discharge_summary']) ?? true,
		visiteDokter : MahasFormat.dynamicToBool(map['visite_dokter']) ?? true,
		resumeRawatJalan : MahasFormat.dynamicToBool(map['resume_rawat_jalan']) ?? true,
    );
  }

	// static AppFeaturesModel fromDynamic(dynamic dynamicData) {
	// 	final model = AppFeaturesModel();

	// 	model.cppt = MahasFormat.dynamicToBool(dynamicData['cppt']) ?? true;
	// 	model.cept = MahasFormat.dynamicToBool(dynamicData['cept']) ?? true;
	// 	model.vitalSign = MahasFormat.dynamicToBool(dynamicData['vital_sign']) ?? true;
	// 	model.persetujuanTindakan = MahasFormat.dynamicToBool(dynamicData['persetujuan_tindakan']) ?? true;
	// 	model.penolakanTindakan = MahasFormat.dynamicToBool(dynamicData['penolakan_tindakan']) ?? true;
	// 	model.telaahResep = MahasFormat.dynamicToBool(dynamicData['telaah_resep']) ?? true;
	// 	model.generalConsent = MahasFormat.dynamicToBool(dynamicData['general_consent']) ?? true;
	// 	model.uploadDokumen = MahasFormat.dynamicToBool(dynamicData['upload_dokumen']) ?? true;
	// 	model.dischargeSummary = MahasFormat.dynamicToBool(dynamicData['discharge_summary']) ?? true;
	// 	model.visiteDokter = MahasFormat.dynamicToBool(dynamicData['visite_dokter']) ?? true;
	// 	model.resumeRawatJalan = MahasFormat.dynamicToBool(dynamicData['resume_rawat_jalan']) ?? true;

	// 	return model;
	// }
}
