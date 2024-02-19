import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/model/kategori_produk_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterKategoriProdukController extends GetxController {
  InputTextController filterCon = InputTextController();
  late ListComponentController<KategoriprodukModel> listCon;

  Rx<Query<KategoriprodukModel>> kategoriProdukList =
      FireStoreQuery.kategoriProdukListDefaultQuery.obs;

  @override
  void onInit() {
    listCon = ListComponentController<KategoriprodukModel>(
      query: kategoriProdukList.value,
      addOnTap: toSetup,
    );
    filterCon.onEditingComplete = () => listCon.query =
        kategoriProdukList.value = FireStoreQuery.kategoriProdukList
            .where('kategori_lowercase',
                isGreaterThanOrEqualTo:
                    filterCon.value.toString().toLowerCase())
            .where('kategori_lowercase',
                isLessThanOrEqualTo:
                    '${filterCon.value.toString().toLowerCase()}\uf8ff')
            .withConverter<KategoriprodukModel>(
              fromFirestore: (snapshot, _) =>
                  KategoriprodukModel.fromDynamic(snapshot),
              toFirestore: (data, _) => KategoriprodukModel.toJSon(data),
            );
    super.onInit();
  }

  void toSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_KATEGORI_PRODUK_SETUP,
      parameters: id != null ? {"id": id} : null,
    )!
        .then(
      (value) {
        filterCon.clearValue();
        listCon.query = kategoriProdukList.value =
            FireStoreQuery.kategoriProdukListDefaultQuery;
      },
    );
  }
}
