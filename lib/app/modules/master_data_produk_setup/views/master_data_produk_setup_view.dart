import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/images/firebase_image_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_dropdown_component.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';

import '../controllers/master_data_produk_setup_controller.dart';

class MasterDataProdukSetupView
    extends GetView<MasterDataProdukSetupController> {
  const MasterDataProdukSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "Data Produk",
      controller: controller.formCon,
      onRefresh: controller.getDropDownValue,
      children: () => [
        InputTextComponent(
          controller: controller.kodeProdukCon,
          label: "Kode Produk",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.namaProdukCon,
          label: "Nama Produk",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputDropdownComponent(
          label: "Unit Satuan Produk",
          controller: controller.unitProdukCon,
          editable: controller.formCon.editable,
          required: true,
          marginBottom: 20,
        ),
        InputDropdownComponent(
          label: "Kategori Produk",
          controller: controller.kategoriProdukCon,
          editable: controller.formCon.editable,
          required: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.stokProdukCon,
          label: "Stok Produk",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.hargaSatuanCon,
          label: "Harga Satuan Produk",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.diskonNonMemberCon,
          label: "Diskon Non Member",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.diskonMemberCon,
          label: "Diskon Member",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.orderLevelCon,
          placeHolder: "Menentukan posisi produk dalam list",
          label: "Order Level",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        FirebaseImageComponent(
          controller: controller.fileCon,
          label: "Gambar",
          editable: controller.formCon.editable,
        ),
      ],
    );
  }
}
