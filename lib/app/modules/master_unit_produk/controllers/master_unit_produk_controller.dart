import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterUnitProdukController extends GetxController {
  InputTextController filterCon = InputTextController();
  late ListComponentController<UnitprodukModel> listCon;

  Rx<Query<UnitprodukModel>> unitProdukList =
      FireStoreQuery.unitProdukListDefaultQuery.obs;

  @override
  void onInit() {
    listCon = ListComponentController<UnitprodukModel>(
      query: unitProdukList.value,
      addOnTap: toUnitSetup,
    );
    filterCon.onEditingComplete = () => listCon.query = unitProdukList.value =
        FireStoreQuery.unitProdukList
            .where('unitLowerCase',
                isGreaterThanOrEqualTo:
                    filterCon.value.toString().toLowerCase())
            .where('unitLowerCase',
                isLessThanOrEqualTo:
                    '${filterCon.value.toString().toLowerCase()}\uf8ff')
            .withConverter<UnitprodukModel>(
              fromFirestore: (snapshot, _) =>
                  UnitprodukModel.fromDynamic(snapshot),
              toFirestore: (unitProduk, _) =>
                  UnitprodukModel.toJSon(unitProduk),
            );
    super.onInit();
  }

  void toUnitSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_UNIT_PRODUK_SETUP,
      parameters: id != null ? {"id": id} : null,
    )!
        .then(
      (value) {
        filterCon.clearValue();
        listCon.query =
            unitProdukList.value = FireStoreQuery.unitProdukListDefaultQuery;
      },
    );
  }
}
