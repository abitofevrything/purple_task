import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class AppVersionRepository {
  AppVersionRepository({required this.asyncPrefs});

  final SharedPreferencesAsync asyncPrefs;

  Future<int?> getAppVersion() => asyncPrefs.getInt(appVersionKey);

  Future<void> setAppVersion() async {
    final currentVersion = await getAppVersion();

    if (currentVersion == null) {
      asyncPrefs.setInt(appVersionKey, 1);
    } else {
      asyncPrefs.setInt(appVersionKey, currentVersion + 1);
    }
  }
}
