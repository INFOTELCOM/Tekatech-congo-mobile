import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfo {
  final String version;
  final String url;
  final String message;

  const UpdateInfo({
    required this.version,
    required this.url,
    required this.message,
  });
}

class UpdateChecker {
  static const String _manifestUrl =
      'https://tekatech-congo.netlify.app/app-version.json';

  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Cache-busting: on force une lecture fraîche du manifeste distant.
      final uri = Uri.parse(_manifestUrl).replace(
        queryParameters: {
          'v': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      final response = await http
          .get(
            uri,
            headers: const {
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint(
          'Vérification mise à jour: HTTP ${response.statusCode}',
        );
        return null;
      }

      final body = response.body.replaceFirst('\uFEFF', '').trim();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final platform = defaultTargetPlatform == TargetPlatform.iOS
          ? 'ios'
          : 'android';

      final platformData = data[platform];

      if (platformData is! Map<String, dynamic>) {
        debugPrint('Vérification mise à jour: bloc $platform absent.');
        return null;
      }

      final latestVersion = platformData['version']?.toString();
      final url = platformData['url']?.toString();

      if (latestVersion == null || url == null) {
        debugPrint('Vérification mise à jour: manifeste incomplet.');
        return null;
      }

      final message = data['message']?.toString() ??
          'Une nouvelle version de TekaTech Congo est disponible.';

      debugPrint(
        'Vérification mise à jour: installée=$currentVersion, disponible=$latestVersion',
      );

      if (!_isNewerVersion(latestVersion, currentVersion)) {
        return null;
      }

      return UpdateInfo(
        version: latestVersion,
        url: url,
        message: message,
      );
    } catch (e, stackTrace) {
      debugPrint('Erreur vérification mise à jour : $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  static Future<void> openUpdate(UpdateInfo update) async {
    final uri = Uri.parse(update.url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static bool _isNewerVersion(String latest, String current) {
    final latestParts = _parseVersion(latest);
    final currentParts = _parseVersion(current);

    final length = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (var i = 0; i < length; i++) {
      final latestPart = i < latestParts.length ? latestParts[i] : 0;
      final currentPart = i < currentParts.length ? currentParts[i] : 0;

      if (latestPart > currentPart) {
        return true;
      }

      if (latestPart < currentPart) {
        return false;
      }
    }

    return false;
  }

  static List<int> _parseVersion(String version) {
    return version
        .split('.')
        .map(
          (part) =>
              int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        )
        .toList();
  }
}
