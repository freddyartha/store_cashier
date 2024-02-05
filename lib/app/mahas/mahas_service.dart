import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_cashier/app/mahas/mahas_colors.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/modules/splash_screen/controllers/splash_screen_controller.dart';
import '../../../firebase_options.dart';
import 'controller/auth_controller.dart';

final remoteConfig = FirebaseRemoteConfig.instance;
final auth = FirebaseAuth.instance;
final authController = AuthController.instance;
final splashController = SplashScreenController.instance;

class MahasService {
  static PackageInfo? packageInfo;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    //screen orientation
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    //init firebase
    await checkFirebase(isInit: true);

    // packageInfo
    packageInfo = await PackageInfo.fromPlatform();

    // getstorange
    await GetStorage.init();

    //locale
    initializeDateFormatting();

    //easyloading
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.dark
      ..radius = 10
      ..progressColor = MahasColors.primary
      ..backgroundColor = MahasColors.dark
      ..indicatorColor = MahasColors.primary
      ..textColor = MahasColors.light
      ..maskColor = MahasColors.dark.withOpacity(0.3)
      ..maskType = EasyLoadingMaskType.custom
      ..textColor = MahasColors.primary
      ..userInteractions = false
      ..indicatorSize = 30
      ..dismissOnTap = false;

    HttpOverrides.global = MyHttpOverrides();
  }

  static Future<void> loadingOverlay(bool withLoadingText) async {
    if (EasyLoading.isShow) await EasyLoading.dismiss();
    await EasyLoading.show(status: withLoadingText ? "Loading Data..." : null)
        .timeout(
      const Duration(seconds: 15),
      onTimeout: () async {
        await EasyLoading.dismiss();
      },
    );
  }

  static Future<void> checkFirebase({bool isInit = false}) async {
    try {
      final Future<FirebaseApp> firebaseInitialization =
          (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS)
              ? Firebase.initializeApp()
              : Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
      await firebaseInitialization.then(
        (value) async {
          // remote config
          await remoteConfig.setConfigSettings(
            RemoteConfigSettings(
              fetchTimeout: const Duration(seconds: 3),
              minimumFetchInterval: Duration.zero,
            ),
          );
          await remoteConfig.fetchAndActivate();
          // getRemoteConfig();
          if (isInit) Get.put(AuthController());
          splashController.isError.value = false;
        },
      );
    } catch (e) {
      splashController.isError.value = true;
    }
  }

  static void getRemoteConfig() {
    // get api from remote config
    String noInternetRemoteConfig =
        remoteConfig.getString("no_internet_error_message");
    if (noInternetRemoteConfig.isNotEmpty) {
      List<dynamic> dataNoInternet = jsonDecode(noInternetRemoteConfig);
      if (dataNoInternet.isNotEmpty) {
        List<String> strlist = dataNoInternet.cast<String>();
        MahasConfig.noInternetErrorMessage.clear();
        MahasConfig.noInternetErrorMessage.addAll(strlist);
      }
    }
  }

  static Future<bool> checkConnection() async {
    bool internet = true;
    final connectivityResult = await Connectivity().checkConnectivity();
    await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      internet = true;
    } else {
      internet = false;
    }
    return internet;
  }

  static bool isInternetCausedError(String error) {
    bool result = true;
    for (var e in MahasConfig.noInternetErrorMessage) {
      if (error.contains(RegExp(e, caseSensitive: false))) {
        result = true;
        break;
      } else {
        result = false;
      }
    }
    return result;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
