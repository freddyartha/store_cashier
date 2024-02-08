import 'package:get/get.dart';

import '../controllers/master_unit_produk_controller.dart';

class MasterUnitProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterUnitProdukController>(
      () => MasterUnitProdukController(),
    );
  }
}
