import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

class MasterUnitProdukSetupController extends GetxController {
  final kodeUnitCon = InputTextController();
  final unitKeteranganCon = InputTextController(type: InputTextType.paragraf);

  late SetupPageController formCon;

  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.unitProdukList,
      urlApiPost: FireStoreQuery.unitProdukList,
      urlApiPut: FireStoreQuery.unitProdukList,
      urlApiDelete: FireStoreQuery.unitProdukList,
      bodyApi: (id) => {
        "unit": kodeUnitCon.value,
        "unitLowerCase": kodeUnitCon.value.toString().toLowerCase(),
        "keterangan": unitKeteranganCon.value,
      },
      apiToView: (json) {
        var model = UnitprodukModel.fromDynamic(json);
        kodeUnitCon.value = model.unit;
        unitKeteranganCon.value = model.keterangan;
      },
      itemKey: (e) => e['id'],
    );
    super.onInit();
  }
}
