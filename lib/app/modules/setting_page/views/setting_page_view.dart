import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  const SettingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
