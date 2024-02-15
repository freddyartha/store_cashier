import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';

import '../controllers/master_kategori_produk_setup_controller.dart';

class MasterKategoriProdukSetupView
    extends GetView<MasterKategoriProdukSetupController> {
  const MasterKategoriProdukSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "Kategori Produk",
      controller: controller.formCon,
      children: () => [
        InputTextComponent(
          controller: controller.kategoriCon,
          label: "Kategori Produk",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.keteranganCon,
          label: "Keterangan",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
      ],
    );
  }
}
