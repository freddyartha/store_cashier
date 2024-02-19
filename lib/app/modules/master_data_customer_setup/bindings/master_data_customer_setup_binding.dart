import 'package:get/get.dart';

import '../controllers/master_data_customer_setup_controller.dart';

class MasterDataCustomerSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterDataCustomerSetupController>(
      () => MasterDataCustomerSetupController(),
    );
  }
}
