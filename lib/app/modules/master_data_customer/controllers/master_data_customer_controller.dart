import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/model/customer_model.dart';

import '../../../firestore_query/reusable_firestore_query.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/components/others/list_component.dart';
import '../../../routes/app_pages.dart';

class MasterDataCustomerController extends GetxController {
  InputTextController filterCon = InputTextController();
  late ListComponentController<CustomerModel> listCon;

  Rx<Query<CustomerModel>> customerList =
      FireStoreQuery.customerListDefaultQuery.obs;

  @override
  void onInit() {
    listCon = ListComponentController<CustomerModel>(
      query: customerList.value,
      addOnTap: toSetup,
    );
    filterCon.onEditingComplete = () => listCon.query = customerList.value =
        FireStoreQuery.customerList
            .where('nama_customer_lowercase',
                isGreaterThanOrEqualTo:
                    filterCon.value.toString().toLowerCase())
            .where('nama_customer_lowercase',
                isLessThanOrEqualTo:
                    '${filterCon.value.toString().toLowerCase()}\uf8ff')
            .withConverter<CustomerModel>(
              fromFirestore: (snapshot, _) =>
                  CustomerModel.fromDynamic(snapshot),
              toFirestore: (data, _) => CustomerModel.toJSon(data),
            );
    super.onInit();
  }

  void toSetup({String? id}) {
    Get.toNamed(
      Routes.MASTER_DATA_CUSTOMER_SETUP,
      parameters: id != null ? {"id": id} : null,
    )!
        .then(
      (value) {
        filterCon.clearValue();
        listCon.query =
            customerList.value = FireStoreQuery.customerListDefaultQuery;
      },
    );
  }
}
