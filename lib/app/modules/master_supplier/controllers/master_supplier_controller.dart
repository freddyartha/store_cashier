import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/model/supplier_model.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

class MasterSupplierController extends GetxController {
  InputTextController filterCon = InputTextController();
  late ListComponentController<SupplierModel> listCon;

  Rx<Query<SupplierModel>> supplierList =
      FireStoreQuery.supplierListDefaultQuery.obs;

  @override
  void onInit() {
    listCon = ListComponentController<SupplierModel>(
      query: supplierList.value,
      addOnTap: toSetup,
    );
    filterCon.onEditingComplete = () => listCon.query = supplierList.value =
        FireStoreQuery.supplierList
            .where('nama_supplier_lowercase',
                isGreaterThanOrEqualTo:
                    filterCon.value.toString().toLowerCase())
            .where('nama_supplier_lowercase',
                isLessThanOrEqualTo:
                    '${filterCon.value.toString().toLowerCase()}\uf8ff')
            .withConverter<SupplierModel>(
              fromFirestore: (snapshot, _) =>
                  SupplierModel.fromDynamic(snapshot),
              toFirestore: (data, _) => SupplierModel.toJSon(data),
            );
    super.onInit();
  }

  void toSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_SUPPLIER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )!
        .then(
      (value) {
        filterCon.clearValue();
        listCon.query =
            supplierList.value = FireStoreQuery.supplierListDefaultQuery;
      },
    );
  }
}
