import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import 'package:store_cashier/app/model/customer_model.dart';

class ItemModel {
  final dynamic id;
  final dynamic text;

  ItemModel({
    this.id,
    this.text,
  });
}

class PenjualanSetupController extends GetxController {
  final InputTextController filterCon = InputTextController();
  late ListComponentController<CustomerModel> listCon;
  late SetupPageController formCon;

  Rx<Query<CustomerModel>> customerList =
      FireStoreQuery.customerListDefaultQuery.obs;
  Rx<ItemModel> pickedCustomer = ItemModel().obs;
  @override
  void onInit() {
    formCon = SetupPageController(
      urlApiGet: FireStoreQuery.unitProdukList,
      urlApiPost: FireStoreQuery.unitProdukList,
      urlApiPut: FireStoreQuery.unitProdukList,
      urlApiDelete: FireStoreQuery.unitProdukList,
      bodyApi: (id) => {
        // "unit": kodeUnitCon.value,
        // "unit_lowercase": kodeUnitCon.value.toString().toLowerCase(),
        // "keterangan": unitKeteranganCon.value,
        if (id == null) "createdAt": FieldValue.serverTimestamp(),
        if (id == null) "createdBy": auth.currentUser!.uid,
        "updatedAt": FieldValue.serverTimestamp(),
        "updatedBy": auth.currentUser!.uid,
      },
      apiToView: (json) {
        // var model = UnitprodukModel.fromDynamic(json);
        // kodeUnitCon.value = model.unit;
        // unitKeteranganCon.value = model.keterangan;
      },
      itemKey: (e) => e['id'],
    );

    listCon = ListComponentController<CustomerModel>(
      query: customerList.value,
      // addOnTap: toSetup,
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

  Future<void> addOnTap() async {
    await showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => MahasWidget.safeAreaWidget(
        child: Scaffold(
          appBar: MahasWidget.mahasAppBar(title: "Pilih Customer"),
          body: ListComponent(
            controller: listCon,
            searchTextComponent: InputTextComponent(
              edgeInsets: const EdgeInsets.only(left: 5),
              borderRadius: Radius.zero,
              placeHolder: "Cari Nama Customer...",
              fillColor: MahasColors.light,
              marginBottom: 0,
              controller: filterCon,
            ),
            itemBuilder: (e) {
              var item = e.data();
              return MahasWidget.uniformCardWidget(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.all(0),
                child: ListTile(
                  onTap: () {
                    pickedCustomer.value =
                        ItemModel(id: e.id, text: item.namaCustomer);
                    Get.back();
                  },
                  title: TextComponent(
                    value: item.namaCustomer,
                    fontSize: MahasFontSize.h6,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: TextComponent(
                    value: item.tipeCustomer == 1 ? "Member" : 'Non Member',
                    isMuted: true,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void deleteItemOnTap() {
    pickedCustomer.value = ItemModel(id: null, text: null);
  }
}
