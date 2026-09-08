import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'content.dart';

class Web3FormsService {
  static Future<bool> submit({
    required Map<String, String> fields,
    required String subject,
  }) async {
    try {
      final uri = Uri.parse('https://api.web3forms.com/submit');

      final payload = {
        'access_key': AppContent.web3formsAccessKey,
        'subject': subject,
        'from_name': 'Application TekaTech Congo',
        ...fields,
      };

      debugPrint('========== WEB3FORMS REQUEST ==========');
      debugPrint('URL : $uri');
      debugPrint('SUBJECT : $subject');
      debugPrint('FIELDS : ${fields.keys.toList()}');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      debugPrint('========== WEB3FORMS RESPONSE ==========');
      debugPrint('STATUS : ${response.statusCode}');
      debugPrint('CONTENT-TYPE : ${response.headers['content-type']}');
      debugPrint('BODY : ${response.body}');
      debugPrint('========================================');

      // Web3Forms a bien reçu la requête.
      // Les réponses HTTP 2xx sont considérées comme un envoi réussi.
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);

          if (data is Map<String, dynamic>) {
            debugPrint('SUCCESS : ${data['success']}');
            debugPrint('MESSAGE : ${data['message']}');

            // Si Web3Forms confirme explicitement le succès.
            if (data['success'] == true) {
              return true;
            }
          }
        } catch (_) {
          // Même si la réponse n'est pas un JSON exploitable,
          // la requête HTTP a été acceptée.
          debugPrint(
            'WEB3FORMS : réponse non JSON, mais requête acceptée.',
          );
        }

        // Statut HTTP 2xx = envoi accepté.
        return true;
      }

      debugPrint(
        'WEB3FORMS : erreur HTTP ${response.statusCode}',
      );

      return false;
    } catch (e, stackTrace) {
      debugPrint('========== WEB3FORMS ERROR ==========');
      debugPrint('ERREUR : $e');
      debugPrint('STACK : $stackTrace');
      debugPrint('=====================================');

      return false;
    }
  }
}