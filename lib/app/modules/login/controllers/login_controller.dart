import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/controller/auth_controller.dart';
import 'package:store_cashier/app/routes/app_pages.dart';

import '../../../mahas/components/inputs/input_text_component.dart';

class LoginController extends GetxController {
  var authCon = AuthController.instance;
  InputTextController emailCon = InputTextController(type: InputTextType.email);
  InputTextController passwordCon =
      InputTextController(type: InputTextType.password);

  void appleLoginOnPress() async {
    await authCon.signInWithApple();
  }

  void googleLoginOnPress() async {
    await authCon.signInWithGoogle();
  }

  void emailLoginOnPressed() async {
    if (emailCon.isValid && passwordCon.isValid) {
      emailCon.clearFocus();
      passwordCon.clearFocus();
      await authCon.singInWithPassword(emailCon.value, passwordCon.value);
    }
  }

  void goToRegister(){
    Get.toNamed(Routes.REGISTER);
  }
}
