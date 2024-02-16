import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:store_cashier/app/firestore_query/reusable_firestore_query.dart';
import 'package:store_cashier/app/mahas/mahas_config.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';
import 'package:store_cashier/app/mahas/services/helper.dart';
import 'package:store_cashier/app/model/company_model.dart';
import 'package:store_cashier/app/model/user_profile_model.dart';

import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());
  final box = GetStorage();
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
    super.onInit();
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      _toLogin();
    } else {
      await getProfileandCompany(
        email: user.email.toString(),
        afterSucces: _toHome,
        afterError: _toRegister,
      );
    }
  }

  static Future<void> getProfileandCompany({
    required String email,
    dynamic Function()? afterSucces,
    dynamic Function()? afterError,
  }) async {
    try {
      QuerySnapshot querySnapshot =
          await FireStoreQuery.tableUser.where("email", isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        MahasConfig.profileModel = UserprofileModel.fromDynamic(
          querySnapshot.docs.first.data(),
        );
        DocumentSnapshot companyGet =
            await FireStoreQuery.companyByIdUser.get();
        if (companyGet.exists) {
          MahasConfig.companyModel =
              CompanyModel.fromDynamic(companyGet.data());
          if (afterSucces != null) {
            afterSucces();
          }
        } else {
          Helper.errorToast(message: "Data Perusahaan Tidak Ditemukan");
        }
      } else {
        if (afterError != null) {
          afterError();
        }
      }
    } catch (e) {
      bool internet = MahasService.isInternetCausedError(e.toString());
      internet ? Helper.errorToast() : Helper.errorToast(message: e.toString());
    }
  }

  Future<UserCredential?> _signInWithCredentialGoogle() async {
    GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    if (googleSignInAccount == null) return null;
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return await auth.signInWithCredential(credential);
  }

  Future<void> singInWithPassword(String email, String pass) async {
    await MahasService.loadingOverlay(false);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      Helper.errorToast(
        message: e.message,
      );
      await EasyLoading.dismiss();
    } catch (e) {
      Helper.errorToast(
        message: e.toString(),
      );
      await EasyLoading.dismiss();
    }
  }

  Future<void> signInWithGoogle() async {
    await MahasService.loadingOverlay(false);
    try {
      await _signInWithCredentialGoogle();
      final box = GetStorage();
      box.write('apple_login', null);
      await EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      Helper.errorToast(
        message: e.message,
      );
      await EasyLoading.dismiss();
    } catch (e) {
      bool interneterror = MahasService.isInternetCausedError(e.toString());
      if (interneterror) {
        Helper.errorToast();
      } else {
        Helper.errorToast(message: e.toString());
      }
      await EasyLoading.dismiss();
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> _signInWithCredentialApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    return await auth.signInWithCredential(oauthCredential);
  }

  Future<void> signInWithApple() async {
    await MahasService.loadingOverlay(false);
    try {
      await _signInWithCredentialApple();
      final box = GetStorage();
      box.write('apple_login', true);
      await EasyLoading.dismiss();
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        Helper.errorToast(message: e.message);
      }
      await EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      Helper.errorToast(
        message: e.message,
      );
      await EasyLoading.dismiss();
    } catch (e) {
      bool internetError = MahasService.isInternetCausedError(e.toString());
      if (internetError) {
        Helper.errorToast();
      } else {
        Helper.errorToast(message: e.toString());
      }
    }
  }

  Future signOut() async {
    await MahasService.loadingOverlay(false);
    await auth.signOut();
    await GoogleSignIn().signOut();
    await EasyLoading.dismiss();
  }

  Future<void> deleteAccount() async {
    final box = GetStorage();
    UserCredential? userCredential;
    try {
      if (box.read('apple_login') == true) {
        userCredential = await _signInWithCredentialApple();
      } else {
        userCredential = await _signInWithCredentialGoogle();
      }
      if (userCredential?.user != null) {
        await userCredential!.user!.delete();
      }
      auth.signOut();
      await GoogleSignIn().signOut();
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        Helper.errorToast(message: e.message);
      }
    } catch (e) {
      bool errorInternet = MahasService.isInternetCausedError(e.toString());
      if (errorInternet) {
        Helper.errorToast();
      } else {
        Helper.errorToast(message: e.toString());
      }
    }
  }

  void _toLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  void _toHome() {
    Get.offAllNamed(Routes.HOME);
  }

  void _toRegister() {
    Get.offAllNamed(Routes.REGISTER);
  }
}
