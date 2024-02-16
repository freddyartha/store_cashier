import 'package:get/get.dart';

import '../controllers/master_data_produk_setup_controller.dart';

class MasterDataProdukSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterDataProdukSetupController>(
      () => MasterDataProdukSetupController(),
    );
  }
}
