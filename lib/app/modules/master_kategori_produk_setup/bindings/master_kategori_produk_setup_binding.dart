import 'package:get/get.dart';

import '../controllers/master_kategori_produk_setup_controller.dart';

class MasterKategoriProdukSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterKategoriProdukSetupController>(
      () => MasterKategoriProdukSetupController(),
    );
  }
}
