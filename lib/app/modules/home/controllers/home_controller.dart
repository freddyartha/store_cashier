import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/models/menu_item_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxString greetingText = "".obs;

  final RxList<MenuItemModel> menus = <MenuItemModel>[].obs;

  @override
  void onInit() {
    refreshData();
    super.onInit();
  }

  @override
  void onClose() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    super.onClose();
  }

  Future<void> refreshData() async {
    await MahasService.loadingOverlay(false);
    await greeting();
    await allowedFeatures();
    await EasyLoading.dismiss();
  }

  void signOutOnPress() async {
    await authController.signOut();
  }

  void settingsOnPress() async {
    Get.toNamed(Routes.SETTING_PAGE);
  }

  Future<void> greeting() async {
    var hour = DateTime.now().hour;
    if (hour >= 00 && hour < 12) {
      greetingText.value = 'Pagi';
    } else if (hour >= 12 && hour < 17) {
      greetingText.value = 'Siang';
    } else {
      greetingText.value = 'Malam';
    }
  }

  Future<void> allowedFeatures() async {
    menus.clear();

    menus.add(
      MenuItemModel(
          title: "Penjualan",
          assetImage: "assets/images/logo.png",
          onTab: penjualanOnTap),
    );

    menus.add(
      MenuItemModel(
          title: "Master Unit Produk",
          assetImage: "assets/images/logo.png",
          onTab: unitOnTap),
    );
    menus.add(
      MenuItemModel(
          title: "Master Kategori Produk",
          assetImage: "assets/images/logo.png",
          onTab: kategoriProdukOnTap),
    );
    menus.add(
      MenuItemModel(
          title: "Master Data Produk",
          assetImage: "assets/images/logo.png",
          onTab: dataProdukOnTap),
    );
    menus.add(
      MenuItemModel(
          title: "Master Supplier",
          assetImage: "assets/images/logo.png",
          onTab: supplierOnTap),
    );
    menus.add(
      MenuItemModel(
          title: "Master Customer",
          assetImage: "assets/images/logo.png",
          onTab: customerOnTap),
    );
  }

  void penjualanOnTap() {
    Get.toNamed(Routes.PENJUALAN_SETUP);
  }

  void unitOnTap() {
    Get.toNamed(Routes.MASTER_UNIT_PRODUK);
  }

  void dataProdukOnTap() {
    Get.toNamed(Routes.MASTER_DATA_PRODUK);
  }

  void kategoriProdukOnTap() {
    Get.toNamed(Routes.MASTER_KATEGORI_PRODUK);
  }

  void supplierOnTap() {
    Get.toNamed(Routes.MASTER_SUPPLIER);
  }

  void customerOnTap() {
    Get.toNamed(Routes.MASTER_DATA_CUSTOMER);
  }
}
