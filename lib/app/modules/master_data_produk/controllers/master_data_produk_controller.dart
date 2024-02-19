import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/model/produk_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterDataProdukController extends GetxController {
  InputTextController filterCon = InputTextController();
  late ListComponentController<ProdukModel> listCon;

  Rx<Query<ProdukModel>> produkList = FireStoreQuery.produkListDefaultQuery.obs;

  @override
  void onInit() {
    listCon = ListComponentController<ProdukModel>(
      query: produkList.value,
      addOnTap: toSetup,
    );
    filterCon.onEditingComplete = () => listCon.query = produkList.value =
        FireStoreQuery.produkList
            .where('nama_produk_lowercase',
                isGreaterThanOrEqualTo:
                    filterCon.value.toString().toLowerCase())
            .where('nama_produk_lowercase',
                isLessThanOrEqualTo:
                    '${filterCon.value.toString().toLowerCase()}\uf8ff')
            .withConverter<ProdukModel>(
              fromFirestore: (snapshot, _) => ProdukModel.fromDynamic(snapshot),
              toFirestore: (data, _) => ProdukModel.toJSon(data),
            );
    super.onInit();
  }

  void toSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_DATA_PRODUK_SETUP,
      parameters: id != null ? {"id": id} : null,
    )!
        .then(
      (value) {
        filterCon.clearValue();
        listCon.query =
            produkList.value = FireStoreQuery.produkListDefaultQuery;
      },
    );
  }
}
