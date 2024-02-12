import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';

import '../controllers/master_unit_produk_setup_controller.dart';

class MasterUnitProdukSetupView
    extends GetView<MasterUnitProdukSetupController> {
  const MasterUnitProdukSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "",
      controller: controller.formCon,
      children: () => [
        InputTextComponent(
          controller: controller.kodeUnitCon,
          label: "Kode Unit",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
          placeHolder: "Pcs",
        ),
        InputTextComponent(
          controller: controller.unitKeteranganCon,
          label: "Keterangan",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          placeHolder: "Pieces",
          marginBottom: 20,
        ),
      ],
    );
  }
}
