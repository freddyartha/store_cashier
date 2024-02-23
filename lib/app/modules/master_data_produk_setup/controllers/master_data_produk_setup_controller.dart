import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/images/firebase_image_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';
import 'package:store_cashier/app/model/produk_model.dart';

class MasterDataProdukSetupController extends GetxController {
  final InputTextController kodeProdukCon = InputTextController();
  final InputTextController namaProdukCon = InputTextController();
  final InputDropdownController unitProdukCon = InputDropdownController();
  final InputDropdownController kategoriProdukCon = InputDropdownController();
  final InputTextController stokProdukCon =
      InputTextController(type: InputTextType.number);
  final InputTextController hargaSatuanCon =
      InputTextController(type: InputTextType.money);
  final InputTextController diskonNonMemberCon =
      InputTextController(type: InputTextType.number);
  final InputTextController diskonMemberCon =
      InputTextController(type: InputTextType.number);
  final InputTextController orderLevelCon =
      InputTextController(type: InputTextType.number);
  final FirebaseImageController fileCon = FirebaseImageController();
  late SetupPageController formCon;
  final Reference imageRef = FirebaseStorage.instance.ref("produk");

  RxList<String> linkFotoProduk = <String>[].obs;

  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.produkList,
      urlApiPost: FireStoreQuery.produkList,
      urlApiPut: FireStoreQuery.produkList,
      urlApiDelete: FireStoreQuery.produkList,
      bodyApi: (id) => {
        "kode_produk": kodeProdukCon.value,
        "nama_produk": namaProdukCon.value,
        "nama_produk_lowercase": namaProdukCon.value.toString().toLowerCase(),
        "unit_id": unitProdukCon.value,
        "kategori_id": kategoriProdukCon.value,
        "stok_produk": stokProdukCon.value,
        "harga_produk": hargaSatuanCon.value,
        "diskon_nonmember": diskonNonMemberCon.value,
        "diskon_member": diskonMemberCon.value,
        "reorder_level": orderLevelCon.value,
        "foto_produk": linkFotoProduk,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if (id == null) "createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      onBeforeSubmit: () {
        if (!kodeProdukCon.isValid) return false;
        if (!namaProdukCon.isValid) return false;
        if (!unitProdukCon.isValid) return false;
        if (!kategoriProdukCon.isValid) return false;
        if (!stokProdukCon.isValid) return false;
        if (!hargaSatuanCon.isValid) return false;

        if (fileCon.values.isNotEmpty) {
          for (var i in fileCon.values) {
            String fileName =
                "${MahasConfig.profileModel.companyId!}/${Helper.idGenerator()}.${i.extension}";
            imageRef.child(fileName).putFile(File(i.path!)).whenComplete(
              () async {
                String downloadURL =
                    await imageRef.child(fileName).getDownloadURL();
                linkFotoProduk.add(downloadURL);
              },
            );
          }
        }

        return true;
      },
      apiToView: (json) async {
        var model = ProdukModel.fromDynamic(json);
        kodeProdukCon.value = model.kodeProduk;
        namaProdukCon.value = model.namaProduk;
        unitProdukCon.value = model.unitId;
        kategoriProdukCon.value = model.kategoriId;
        stokProdukCon.value = model.stokProduk;
        hargaSatuanCon.value = model.hargaProduk;
        diskonNonMemberCon.value = model.diskonNonMember;
        diskonMemberCon.value = model.diskonMember;
        orderLevelCon.value = model.reorderlevel;
        fileCon.values = model.fotoProduk ?? [];
      },
      itemKey: (e) => e['id'],
      onInit: () async {
        await getDropDownValue();
      },
    );
    super.onInit();
  }

  Future<void> getDropDownValue() async {
    try {
      RxList<DropdownItem> listUnit = RxList<DropdownItem>();
      listUnit.clear();
      if (unitProdukCon.items.isNotEmpty) unitProdukCon.items.clear();
      var units = await FireStoreQuery.unitProdukList.get();
      for (var e in units.docs) {
        listUnit.add(DropdownItem.init(e["unit"], e.id));
      }
      unitProdukCon.items = listUnit;

      RxList<DropdownItem> listKategori = RxList<DropdownItem>();
      listKategori.clear();
      if (kategoriProdukCon.items.isNotEmpty) kategoriProdukCon.items.clear();
      var kategoris = await FireStoreQuery.kategoriProdukList.get();
      for (var e in kategoris.docs) {
        listKategori.add(DropdownItem.init(e["kategori"], e.id));
      }
      kategoriProdukCon.items = listKategori;
    } on FirebaseException catch (e) {
      bool internetError = MahasService.isInternetCausedError(e.toString());
      if (internetError) {
        Helper.errorToast();
      } else {
        Helper.errorToast(message: e.message);
      }
    } catch (e) {
      bool internetError = MahasService.isInternetCausedError(e.toString());
      if (internetError) {
        Helper.errorToast();
      } else {
        Helper.errorToast(message: e.toString());
      }
    }
  }
}
