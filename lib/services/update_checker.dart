import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateInfo {
  final String version;
  final String apkUrl;
  final String message;
  final bool forceUpdate;

  const AppUpdateInfo({
    required this.version,
    required this.apkUrl,
    required this.message,
    required this.forceUpdate,
  });
}

class UpdateChecker {
  static const _manifestUrl =
      'https://raw.githubusercontent.com/INFOTELCOM/Teka-Tech-Congo/main/app-version.json';

  static Future<AppUpdateInfo?> check() async {
    try {
      final package = await PackageInfo.fromPlatform();
      final current = _version(package.version);

      final response = await http
          .get(Uri.parse(_manifestUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;

      final latestVersion = data['version']?.toString();
      final apkUrl = data['apk_url']?.toString();
      if (latestVersion == null || apkUrl == null || latestVersion.isEmpty || apkUrl.isEmpty) {
        return null;
      }

      if (_compareVersions(latestVersion, current) <= 0) return null;

      return AppUpdateInfo(
        version: latestVersion,
        apkUrl: apkUrl,
        message: data['message']?.toString() ?? 'Une nouvelle version est disponible.',
        forceUpdate: data['force_update'] == true,
      );
    } catch (e) {
      debugPrint('UPDATE CHECKER: $e');
      return null;
    }
  }

  static Future<void> openUpdate(AppUpdateInfo info) async {
    final uri = Uri.parse(info.apkUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static List<int> _version(String value) => value
      .split('.')
      .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
      .toList();

  static int _compareVersions(String a, List<int> b) {
    final av = _version(a);
    final length = av.length > b.length ? av.length : b.length;
    for (var i = 0; i < length; i++) {
      final ai = i < av.length ? av[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai != bi) return ai.compareTo(bi);
    }
    return 0;
  }
}
