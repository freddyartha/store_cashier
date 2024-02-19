import 'package:get/get.dart';

import '../controllers/master_data_customer_controller.dart';

class MasterDataCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterDataCustomerController>(
      () => MasterDataCustomerController(),
    );
  }
}
