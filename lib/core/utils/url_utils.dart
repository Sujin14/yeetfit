import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the device browser.
Future<void> launchUrlExternal(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
