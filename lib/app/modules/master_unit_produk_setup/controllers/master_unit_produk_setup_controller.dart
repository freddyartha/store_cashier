import 'dart:convert';

import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

class MasterUnitProdukSetupController extends GetxController {
  final kodeUnitCon = InputTextController();
  final unitKeteranganCon = InputTextController(type: InputTextType.paragraf);

  late SetupPageController formCon;
  String? id;

  @override
  void onInit() {
    id = Get.parameters["id"];
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.unitProdukList.doc(id),
      urlApiPost: FireStoreQuery.unitProdukList,
      urlApiPut: FireStoreQuery.unitProdukList.doc(id),
      urlApiDelete: FireStoreQuery.unitProdukList.doc(id),
      bodyApi: (id) => {
        "unit": kodeUnitCon.value,
        "keterangan": unitKeteranganCon.value,
      },
      apiToView: (json) {
        var model = UnitprodukModel.fromDynamic(json);
        kodeUnitCon.value = model.unit;
        unitKeteranganCon.value = model.keterangan;
      },
      itemKey: (e) => e['id'],
      itemIdAfterSubmit: (e) => json.decode(e)['id'],
    );
    super.onInit();
  }
}
