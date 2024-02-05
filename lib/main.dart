import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';

import 'app/mahas/components/mahas_themes.dart';
import 'app/routes/app_pages.dart';

void main() {
  MahasService.init();
  runApp(
    GetMaterialApp(
      theme: MahasThemes.light,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    ),
  );
}
