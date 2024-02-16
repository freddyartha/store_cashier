import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_cashier/app/model/company_model.dart';
import 'package:store_cashier/app/model/user_profile_model.dart';

class MahasConfig {
  static bool isLaravelBackend = false;
  static int timeLimit = 5;
  static UserprofileModel profileModel = UserprofileModel();
  static CompanyModel companyModel = CompanyModel();
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static List<String> noInternetErrorMessage = [
    'A network error',
    'failed host lookup',
    'user was not linked',
    'unexpected end of stream',
    'network_error',
    'Unable to resolve host',
  ];
}
