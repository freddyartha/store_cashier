import 'package:get/get.dart';

import '../controllers/master_data_produk_controller.dart';

class MasterDataProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterDataProdukController>(
      () => MasterDataProdukController(),
    );
  }
}
