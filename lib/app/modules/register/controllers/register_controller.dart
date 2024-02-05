import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';

class RegisterController extends GetxController {
  final InputTextController namaLengkapCon = InputTextController();
  final InputTextController namaPerusahaanCon = InputTextController();
  final InputTextController noHandphoneCon =
      InputTextController(type: InputTextType.phone);
  final InputTextController alamatCon =
      InputTextController(type: InputTextType.paragraf);
  final InputTextController alamatPerusahaanCon =
      InputTextController(type: InputTextType.paragraf);

  final InputTextController idPerusahaanCon = InputTextController();

  RxBool alreadyHaveCompany = false.obs;
  RxBool isInitDone = false.obs;

  void companyOnTap(bool already) {
    if (already) {
      alreadyHaveCompany.value = true;
    } else {
      alreadyHaveCompany.value = false;
    }
    isInitDone.value = true;
  }
}
