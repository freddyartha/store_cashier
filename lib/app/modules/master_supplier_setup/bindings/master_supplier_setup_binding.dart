import 'package:get/get.dart';

import '../controllers/master_supplier_setup_controller.dart';

class MasterSupplierSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterSupplierSetupController>(
      () => MasterSupplierSetupController(),
    );
  }
}
