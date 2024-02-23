import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_radio_component.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/components/pages/setup_page_component.dart';
import '../controllers/master_data_customer_setup_controller.dart';

class MasterDataCustomerSetupView
    extends GetView<MasterDataCustomerSetupController> {
  const MasterDataCustomerSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "Data Customer",
      controller: controller.formCon,
      children: () => [
        InputTextComponent(
          controller: controller.namaCustomerCon,
          label: "Nama Customer",
          editable: controller.formCon.editable,
          isRequired: true,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputRadioComponent(
          controller: controller.tipeCustomerCon,
          label: "Tipe Customer",
          editable: controller.formCon.editable,
          required: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.kontakCustomerCon,
          label: "No. HP",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
        InputTextComponent(
          controller: controller.alamatCustomerCon,
          label: "Alamat Customer",
          editable: controller.formCon.editable,
          isBorderRectangle: true,
          marginBottom: 20,
        ),
      ],
    );
  }
}
