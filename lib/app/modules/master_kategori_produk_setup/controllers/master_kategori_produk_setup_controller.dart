import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/model/kategori_produk_model.dart';

class MasterKategoriProdukSetupController extends GetxController {
  final kategoriCon = InputTextController();
  final keteranganCon = InputTextController(type: InputTextType.paragraf);

  late SetupPageController formCon;

  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.kategoriProdukList,
      urlApiPost: FireStoreQuery.kategoriProdukList,
      urlApiPut: FireStoreQuery.kategoriProdukList,
      urlApiDelete: FireStoreQuery.kategoriProdukList,
      bodyApi: (id) => {
        "kategori": kategoriCon.value,
        "kategoriLowerCase": kategoriCon.value.toString().toLowerCase(),
        "keterangan": keteranganCon.value,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if (id == null) "createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      apiToView: (json) {
        var model = KategoriprodukModel.fromDynamic(json);
        kategoriCon.value = model.kategori;
        keteranganCon.value = model.keterangan;
      },
      itemKey: (e) => e['id'],
    );
    super.onInit();
  }
}
