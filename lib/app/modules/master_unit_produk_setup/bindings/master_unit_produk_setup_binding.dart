import 'package:get/get.dart';

import '../controllers/master_unit_produk_setup_controller.dart';

class MasterUnitProdukSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterUnitProdukSetupController>(
      () => MasterUnitProdukSetupController(),
    );
  }
}
