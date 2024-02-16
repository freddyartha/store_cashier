import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/model/supplier_model.dart';

class MasterSupplierSetupController extends GetxController {
  final kodeSupplierCon = InputTextController();
  final namaSupplierCon = InputTextController();
  final kontakSupplierCon = InputTextController(type: InputTextType.phone);
  final emailSupplierCon = InputTextController(type: InputTextType.email);
  final alamatSupplierCon = InputTextController(type: InputTextType.paragraf);

  late SetupPageController formCon;

  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.supplierList,
      urlApiPost: FireStoreQuery.supplierList,
      urlApiPut: FireStoreQuery.supplierList,
      urlApiDelete: FireStoreQuery.supplierList,
      bodyApi: (id) => {
        "kodeSupplier": kodeSupplierCon.value,
        "namaSupplier": namaSupplierCon.value,
        "namaSupplierLowerCase": namaSupplierCon.value.toString().toLowerCase(),
        "kontakSupplier": kontakSupplierCon.value,
        "emailSupplier": emailSupplierCon.value,
        "alamatSupplier": alamatSupplierCon.value,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if(id == null)"createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      apiToView: (json) {
        var model = SupplierModel.fromDynamic(json);
        kodeSupplierCon.value = model.kodesupplier;
        namaSupplierCon.value = model.namasupplier;
        kontakSupplierCon.value = model.kontaksupplier;
        emailSupplierCon.value = model.emailsupplier;
        alamatSupplierCon.value = model.alamatsupplier;
      },
      itemKey: (e) => e['id'],
    );
    super.onInit();
  }
}
