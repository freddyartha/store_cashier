import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/components/others/empty_component.dart';
import 'package:store_cashier/app/mahas/components/others/shimmer_component.dart';
import 'package:store_cashier/app/mahas/components/texts/text_component.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_font_size.dart';
import 'package:store_cashier/app/mahas/mahas_widget.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';
import 'package:store_cashier/app/model/unit_produk_model.dart';

import '../controllers/master_unit_produk_controller.dart';

class MasterUnitProdukView extends GetView<MasterUnitProdukController> {
  const MasterUnitProdukView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MahasWidget.mahasAppBar(title: "Master Unit Produk"),
      body: MahasWidget.safeAreaWidget(
        child: Stack(
          children: [
            MahasWidget.backgroundWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FirestoreListView<UnitprodukModel>(
                query: controller.unitProdukList,
                emptyBuilder: (context) => const EmptyComponent(),
                loadingBuilder: (context) => const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ShimmerComponent(),
                ),
                errorBuilder: (context, error, stackTrace) =>
                    Helper.errorToast(message: error.toString()),
                itemBuilder: (context, doc) {
                  var item = doc.data();
                  return MahasWidget.uniformCardWidget(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      onTap: () => controller.toUnitSetup(id: doc.id),
                      title: TextComponent(
                        value: item.unit,
                        fontSize: MahasFontSize.h6,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: TextComponent(
                        value: item.keterangan,
                        isMuted: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    //buatkan fungsi add list
                    onPressed: controller.toUnitSetup,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: MahasColors.light,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color: MahasColors.primary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
