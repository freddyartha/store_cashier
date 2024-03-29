import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invoice/bindings/invoice_binding.dart';
import '../modules/invoice/views/invoice_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/master_data_customer/bindings/master_data_customer_binding.dart';
import '../modules/master_data_customer/views/master_data_customer_view.dart';
import '../modules/master_data_customer_setup/bindings/master_data_customer_setup_binding.dart';
import '../modules/master_data_customer_setup/views/master_data_customer_setup_view.dart';
import '../modules/master_data_produk/bindings/master_data_produk_binding.dart';
import '../modules/master_data_produk/views/master_data_produk_view.dart';
import '../modules/master_data_produk_setup/bindings/master_data_produk_setup_binding.dart';
import '../modules/master_data_produk_setup/views/master_data_produk_setup_view.dart';
import '../modules/master_kategori_produk/bindings/master_kategori_produk_binding.dart';
import '../modules/master_kategori_produk/views/master_kategori_produk_view.dart';
import '../modules/master_kategori_produk_setup/bindings/master_kategori_produk_setup_binding.dart';
import '../modules/master_kategori_produk_setup/views/master_kategori_produk_setup_view.dart';
import '../modules/master_supplier/bindings/master_supplier_binding.dart';
import '../modules/master_supplier/views/master_supplier_view.dart';
import '../modules/master_supplier_setup/bindings/master_supplier_setup_binding.dart';
import '../modules/master_supplier_setup/views/master_supplier_setup_view.dart';
import '../modules/master_unit_produk/bindings/master_unit_produk_binding.dart';
import '../modules/master_unit_produk/views/master_unit_produk_view.dart';
import '../modules/master_unit_produk_setup/bindings/master_unit_produk_setup_binding.dart';
import '../modules/master_unit_produk_setup/views/master_unit_produk_setup_view.dart';
import '../modules/penjualan_setup/bindings/penjualan_setup_binding.dart';
import '../modules/penjualan_setup/views/penjualan_setup_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting_page/bindings/setting_page_binding.dart';
import '../modules/setting_page/views/setting_page_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_PAGE,
      page: () => const SettingPageView(),
      binding: SettingPageBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_UNIT_PRODUK,
      page: () => const MasterUnitProdukView(),
      binding: MasterUnitProdukBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_UNIT_PRODUK_SETUP,
      page: () => const MasterUnitProdukSetupView(),
      binding: MasterUnitProdukSetupBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_DATA_PRODUK,
      page: () => const MasterDataProdukView(),
      binding: MasterDataProdukBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_KATEGORI_PRODUK,
      page: () => const MasterKategoriProdukView(),
      binding: MasterKategoriProdukBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_KATEGORI_PRODUK_SETUP,
      page: () => const MasterKategoriProdukSetupView(),
      binding: MasterKategoriProdukSetupBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_SUPPLIER,
      page: () => const MasterSupplierView(),
      binding: MasterSupplierBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_SUPPLIER_SETUP,
      page: () => const MasterSupplierSetupView(),
      binding: MasterSupplierSetupBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_DATA_PRODUK_SETUP,
      page: () => const MasterDataProdukSetupView(),
      binding: MasterDataProdukSetupBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_DATA_CUSTOMER,
      page: () => const MasterDataCustomerView(),
      binding: MasterDataCustomerBinding(),
    ),
    GetPage(
      name: _Paths.MASTER_DATA_CUSTOMER_SETUP,
      page: () => const MasterDataCustomerSetupView(),
      binding: MasterDataCustomerSetupBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE,
      page: () => const InvoiceView(),
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: _Paths.PENJUALAN_SETUP,
      page: () => const PenjualanSetupView(),
      binding: PenjualanSetupBinding(),
    ),
  ];
}
