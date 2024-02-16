enum PhotoType { ktp, photoProfile, familyCard, selfie, kwitasi, gambar }

extension PhotoTypeExtension on PhotoType {
  String get title {
    switch (this) {
      case PhotoType.ktp:
        return "KTP";
      case PhotoType.familyCard:
        return "FAMILY_CARD";
      case PhotoType.photoProfile:
        return "PHOTO_PROFILE";
      case PhotoType.selfie:
        return "SELFIE";
      case PhotoType.kwitasi:
        return "KWITANSI";
      case PhotoType.gambar:
        return "GAMBAR";
      default:
        return "N/A";
    }
  }

  String get descTitle {
    switch (this) {
      case PhotoType.ktp:
        return "Foto E-KTP";
      case PhotoType.familyCard:
        return "Foto Kartu Keluarga";
      case PhotoType.photoProfile:
        return "Foto Profil";
      case PhotoType.selfie:
        return "Foto Selfie";
      case PhotoType.kwitasi:
        return "Foto Kwitansi";
      case PhotoType.gambar:
        return "Gambar";
      default:
        return "N/A";
    }
  }

  List<String> get content {
    switch (this) {
      case PhotoType.ktp:
        return ["Pastikan posisi foto e-KTP dapat terbaca dengan jelas."];
      case PhotoType.familyCard:
        return [
          'Pastikan posisi foto Kartu Keluar dapat terbaca dengan jelas.'
        ];
      case PhotoType.photoProfile:
        return ['Pastikan wajah terlihat dengan jelas agar mudah dikenali.'];
      case PhotoType.selfie:
        return [
          'Pastikan foto wajah Anda terlihat dengan jelas agar mudah dikenali'
        ];
      case PhotoType.kwitasi:
        return ["Pastikan informasi didalam kwintasi terlihat dengan jelas."];
      case PhotoType.gambar:
        return ["Pastikan gambar terlihat dengan jelas."];
      default:
        return ["N/A"];
    }
  }

  List<String> get image {
    switch (this) {
      case PhotoType.ktp:
        return ["assets/images/ktp_placeholder.png"];
      case PhotoType.familyCard:
        return ["assets/images/kk_placeholder.png"];
      case PhotoType.photoProfile:
        return [
          "assets/images/photo_profile_placeholder.png",
          "assets/images/wrong_photo_profile_placeholder.png"
        ];
      case PhotoType.selfie:
        return [
          "assets/images/photo_profile_placeholder.png",
          "assets/images/wrong_photo_profile_placeholder.png"
        ];
      default:
        return ["N/A"];
    }
  }
}
