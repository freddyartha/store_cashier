import 'package:get/get.dart';

import '../controllers/master_supplier_controller.dart';

class MasterSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterSupplierController>(
      () => MasterSupplierController(),
    );
  }
}
