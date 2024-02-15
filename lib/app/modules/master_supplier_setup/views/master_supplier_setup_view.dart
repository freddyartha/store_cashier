import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';

import '../controllers/master_supplier_setup_controller.dart';

class MasterSupplierSetupView extends GetView<MasterSupplierSetupController> {
  const MasterSupplierSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "Supplier",
      controller: controller.formCon,
      children: () => [
        InputTextComponent(
          controller: controller.kodeSupplierCon,
          label: "Kode",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.namaSupplierCon,
          label: "Nama",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.kontakSupplierCon,
          label: "No. HP",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.emailSupplierCon,
          label: "Alamat E-mail",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.alamatSupplierCon,
          label: "Alamat",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
      ],
    );
  }
}
