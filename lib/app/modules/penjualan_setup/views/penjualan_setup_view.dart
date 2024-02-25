import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_radio_component.dart';
import 'package:store_cashier/app/mahas/components/pages/setup_page_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';

import '../controllers/penjualan_setup_controller.dart';

class PenjualanSetupView extends GetView<PenjualanSetupController> {
  const PenjualanSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SetupPageComponent(
      title: "Penjualan",
      controller: controller.formCon,
      children: () => [
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextComponent(
                value: "Nama Customer",
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              controller.pickedCustomer.value.id != null
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextComponent(
                              value: controller.pickedCustomer.value.text,
                            ),
                          ),
                          InkWell(
                            onTap: controller.deleteItemOnTap,
                            child: SizedBox(
                              width: 50,
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: MahasColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: controller.addOnTap,
                      child: SizedBox(
                        width: Get.width,
                        height: 40,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.circlePlus,
                            color: MahasColors.primary,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        InputRadioComponent(
          controller: controller.tipePembayaranCon,
          label: "Tipe Pembayaran",
          editable: controller.formCon.editable,
          required: true,
          marginBottom: 20,
        ),
        // InputTextComponent(
        //   controller: controller.unitKeteranganCon,
        //   label: "Keterangan",
        //   editable: controller.formCon.editable,
        //   isBorderRectangle: true,
        //   marginBottom: 20,
        // ),
      ],
    );
  }
}
