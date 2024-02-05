import 'package:package_info_plus/package_info_plus.dart';

enum MahasEnvironmentType { dev, prd }

class MahasEnvironment {
  static MahasEnvironmentType? current;

  MahasEnvironment() {
    PackageInfo.fromPlatform().then((value) {
      switch (value.packageName) {
        case "com.sanata.haimed.dinkesbadung.dev":
          current = MahasEnvironmentType.dev;
          break;
        default:
          current = MahasEnvironmentType.prd;
          break;
      }
    });
  }
}
