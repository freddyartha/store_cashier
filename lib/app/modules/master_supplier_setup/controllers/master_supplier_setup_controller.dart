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
        "kode_supplier": kodeSupplierCon.value,
        "nama_supplier": namaSupplierCon.value,
        "nama_supplier_lowercase": namaSupplierCon.value.toString().toLowerCase(),
        "kontak_supplier": kontakSupplierCon.value,
        "email_supplier": emailSupplierCon.value,
        "alamat_supplier": alamatSupplierCon.value,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if(id == null)"createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      apiToView: (json) {
        var model = SupplierModel.fromDynamic(json);
        kodeSupplierCon.value = model.kodeSupplier;
        namaSupplierCon.value = model.namaSupplier;
        kontakSupplierCon.value = model.kontakSupplier;
        emailSupplierCon.value = model.emailSupplier;
        alamatSupplierCon.value = model.alamatSupplier;
      },
      itemKey: (e) => e['id'],
    );
    super.onInit();
  }
}
