import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterUnitProdukController extends GetxController {
  final unitProdukList =
      FireStoreQuery.unitProdukList.withConverter<UnitprodukModel>(
    fromFirestore: (snapshot, _) => UnitprodukModel.fromDynamic(snapshot),
    toFirestore: (unitProduk, _) => UnitprodukModel.toJSon(unitProduk),
  );

  void toUnitSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_UNIT_PRODUK_SETUP,
      parameters: id != null ? {"id": id} : null,
    );
  }
}
