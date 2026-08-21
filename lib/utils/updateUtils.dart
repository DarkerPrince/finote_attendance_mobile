import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdateUtils {
  static Future<PackageInfo> getAppInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future<String> getCurrentVersion() async {
    final packageInfo = await getAppInfo();
    return packageInfo.version;
  }

  static Future<int> getCurrentBuildNumber() async {
    final packageInfo = await getAppInfo();
    return int.parse(packageInfo.buildNumber);
  }

  static Future<Map<String, dynamic>> checkForUpdate(String apiBaseUrl) async {
    try {
      final currentVersion = await getCurrentVersion();
      final currentBuildNumber = await getCurrentBuildNumber();

      final response = await http.get(
        Uri.parse('$apiBaseUrl/app/version'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['version'] ?? '';
        final latestBuildNumber = data['buildNumber'] ?? 0;
        final storeUrl = data['storeUrl'] ?? '';
        final updateMessage = data['updateMessage'] ?? 'A new version is available.';

        final hasUpdate = _isNewerVersion(currentVersion, latestVersion) ||
            currentBuildNumber < latestBuildNumber;

        return {
          'hasUpdate': hasUpdate,
          'currentVersion': currentVersion,
          'latestVersion': latestVersion,
          'storeUrl': storeUrl,
          'updateMessage': updateMessage,
        };
      }
    } catch (e) {
      // Silently fail - don't block app usage
    }

    return {
      'hasUpdate': false,
      'currentVersion': '',
      'latestVersion': '',
      'storeUrl': '',
      'updateMessage': '',
    };
  }

  static bool _isNewerVersion(String currentVersion, String latestVersion) {
    try {
      final currentParts = currentVersion.split('.');
      final latestParts = latestVersion.split('.');

      for (var i = 0; i < latestParts.length; i++) {
        final current = i < currentParts.length ? int.parse(currentParts[i]) : 0;
        final latest = int.parse(latestParts[i]);

        if (latest > current) return true;
        if (latest < current) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
