import 'package:get/get.dart';

import '../controllers/master_kategori_produk_controller.dart';

class MasterKategoriProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterKategoriProdukController>(
      () => MasterKategoriProdukController(),
    );
  }
}
