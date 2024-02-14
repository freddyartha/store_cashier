import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/master_data_produk_controller.dart';

class MasterDataProdukView extends GetView<MasterDataProdukController> {
  const MasterDataProdukView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MasterDataProdukView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MasterDataProdukView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
