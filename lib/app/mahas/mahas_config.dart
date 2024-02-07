import 'package:cloud_firestore/cloud_firestore.dart';

class MahasConfig {
  static bool isLaravelBackend = false;
  static int timeLimit = 5;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static List<String> noInternetErrorMessage = [
    'A network error',
    'failed host lookup',
    'user was not linked',
    'unexpected end of stream',
    'network_error',
  ];
}
