import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterUnitProdukController extends GetxController {
  InputTextController filterCon = InputTextController();
  Rx<Query<UnitprodukModel>> unitProdukList = FireStoreQuery.unitProdukList
      .where("unit", isNull: false)
      .withConverter<UnitprodukModel>(
        fromFirestore: (snapshot, _) => UnitprodukModel.fromDynamic(snapshot),
        toFirestore: (unitProduk, _) => UnitprodukModel.toJSon(unitProduk),
      )
      .obs;

  @override
  void onInit() {
    filterCon.onEditingComplete = () => unitProdukList.value = FireStoreQuery
        .unitProdukList
        .where('unitLowerCase', isGreaterThanOrEqualTo: filterCon.value.toString().toLowerCase())
        .where('unitLowerCase', isLessThanOrEqualTo: '${filterCon.value.toString().toLowerCase()}\uf8ff')
        .withConverter<UnitprodukModel>(
          fromFirestore: (snapshot, _) => UnitprodukModel.fromDynamic(snapshot),
          toFirestore: (unitProduk, _) => UnitprodukModel.toJSon(unitProduk),
        );

    super.onInit();
  }

  void toUnitSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_UNIT_PRODUK_SETUP,
      parameters: id != null ? {"id": id} : null,
    );
  }
}
