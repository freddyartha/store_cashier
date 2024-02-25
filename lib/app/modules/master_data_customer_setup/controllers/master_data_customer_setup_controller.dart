import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_radio_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/model/customer_model.dart';

import '../../../mahas/components/pages/setup_page_component.dart';

class MasterDataCustomerSetupController extends GetxController {
  final namaCustomerCon = InputTextController();
  final kontakCustomerCon = InputTextController(type: InputTextType.phone);
  final alamatCustomerCon = InputTextController(type: InputTextType.paragraf);
  final tipeCustomerCon = InputRadioController(
    items: [
      RadioButtonItem(
        value: 1,
        text: "Member",
      ),
      RadioButtonItem(
        value: 2,
        text: "Non Member",
      ),
    ],
  );

  late SetupPageController formCon;

  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.customerList,
      urlApiPost: FireStoreQuery.customerList,
      urlApiPut: FireStoreQuery.customerList,
      urlApiDelete: FireStoreQuery.customerList,
      bodyApi: (id) => {
        "nama_customer": namaCustomerCon.value,
        "tipe_customer": tipeCustomerCon.value,
        "nama_customer_lowercase":
            namaCustomerCon.value.toString().toLowerCase(),
        "kontak_customer": kontakCustomerCon.value,
        "alamat_customer": alamatCustomerCon.value,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if (id == null) "createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      apiToView: (json) {
        var model = CustomerModel.fromDynamic(json);
        namaCustomerCon.value = model.namaCustomer;
        tipeCustomerCon.value = model.tipeCustomer;
        kontakCustomerCon.value = model.kontakCustomer;
        alamatCustomerCon.value = model.alamatCustomer;
      },
      itemKey: (e) => e['id'],
    );
    super.onInit();
  }
}
