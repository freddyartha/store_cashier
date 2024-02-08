import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

import '../../../mahas/mahas_service.dart';

class MasterUnitProdukController extends GetxController {
  RxBool isEmpty = false.obs;
  RxBool isLoading = false.obs;
  RxList<UnitprodukModel> listUnit = <UnitprodukModel>[].obs;

  @override
  void onInit() async {
    await getUnitList();
    super.onInit();
  }

  Future<void> getUnitList() async {
    isLoading.value = true;
    try {
      var company = await FireStoreQuery.companyByIdUser.get();
      if (company.exists) {
        QuerySnapshot getUnit = await FireStoreQuery.unitProdukList.get();
        if (getUnit.docs.isNotEmpty) {
          for (var e in getUnit.docs) {
            listUnit.add(
              UnitprodukModel.fromDynamic(e),
            );
          }
        } else {
          await FireStoreQuery.unitProdukList.add(
            {"unit": "Pcs", "keterangan": "Pieces"},
          );
          QuerySnapshot getUnit = await FireStoreQuery.unitProdukList.get();
          for (var e in getUnit.docs) {
            listUnit.add(
              UnitprodukModel.fromDynamic(e),
            );
          }
        }
      } else {
        isEmpty.value = true;
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      bool internet = MahasService.isInternetCausedError(e.toString());
      internet ? Helper.errorToast() : Helper.errorToast(message: e.toString());
    }
  }
}
