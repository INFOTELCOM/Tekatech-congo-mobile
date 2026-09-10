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
  static const String _fallbackUpdateUrl =
      'https://tekatech-congo.netlify.app/applications.html';

  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

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

    try {
      // Ne pas bloquer sur canLaunchUrl(): sur certains appareils Android,
      // cette vérification peut retourner false alors que launchUrl() fonctionne.
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        return;
      }
    } catch (e, stackTrace) {
      debugPrint('Ouverture de la mise à jour impossible : $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    // Secours : ouvrir la page Applications si le téléchargement direct
    // n'est pas pris en charge par le navigateur/appareil.
    try {
      await launchUrl(
        Uri.parse(_fallbackUpdateUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e, stackTrace) {
      debugPrint('Ouverture de la page de secours impossible : $e');
      debugPrintStack(stackTrace: stackTrace);
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
