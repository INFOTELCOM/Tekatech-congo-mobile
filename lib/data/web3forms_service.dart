import 'dart:convert';
import 'package:http/http.dart' as http;
import 'content.dart';

/// Envoie un formulaire via Web3Forms — le même service et la même
/// clé publique que ceux utilisés par le site web (script.js),
/// pour que les demandes envoyées depuis l'appli arrivent exactement
/// au même endroit (contact.infotelcom@gmail.com).
class Web3FormsService {
  static Future<bool> submit({
    required Map<String, String> fields,
    required String subject,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'access_key': AppContent.web3formsAccessKey,
          'subject': subject,
          'from_name': 'Application TekaTech Congo',
          ...fields,
        }),
      );
      if (response.statusCode != 200) return false;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
