import 'package:get/get.dart';

import '../controllers/penjualan_setup_controller.dart';

class PenjualanSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenjualanSetupController>(
      () => PenjualanSetupController(),
    );
  }
}
