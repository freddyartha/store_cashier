import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/inputs/input_text_component.dart';
import 'package:store_cashier/app/mahas/components/others/list_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import 'package:store_cashier/app/model/customer_model.dart';

import '../controllers/master_data_customer_controller.dart';

class MasterDataCustomerView extends GetView<MasterDataCustomerController> {
  const MasterDataCustomerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MahasWidget.mahasAppBar(title: "Master Customer"),
        body: MahasWidget.safeAreaWidget(
          child: ListComponent<CustomerModel>(
            controller: controller.listCon,
            searchTextComponent: InputTextComponent(
              edgeInsets: const EdgeInsets.only(left: 5),
              borderRadius: Radius.zero,
              placeHolder: "Cari Nama Customer...",
              fillColor: MahasColors.light,
              marginBottom: 0,
              controller: controller.filterCon,
            ),
            itemBuilder: (e) {
              var item = e.data();
              print(item.tipeCustomer);
              return MahasWidget.uniformCardWidget(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.all(0),
                child: ListTile(
                  onTap: () => controller.toSetup(id: e.id),
                  title: TextComponent(
                    value: item.namaCustomer,
                    fontSize: MahasFontSize.h6,
                    fontWeight: FontWeight.w600,
                  ),
                  subtitle: TextComponent(
                    value: CustomerModel.getTipeCustomer(item.tipeCustomer),
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
}
