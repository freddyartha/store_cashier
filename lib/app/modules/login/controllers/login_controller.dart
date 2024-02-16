import 'package:get/get.dart';
import 'package:store_cashier/app/mahas/mahas_service.dart';

import '../../../mahas/components/inputs/input_text_component.dart';

class LoginController extends GetxController {
  InputTextController emailCon = InputTextController(type: InputTextType.email);
  InputTextController passwordCon =
      InputTextController(type: InputTextType.password);

  void appleLoginOnPress() async {
    await authController.signInWithApple();
  }

  void googleLoginOnPress() async {
    await authController.signInWithGoogle();
  }
}
