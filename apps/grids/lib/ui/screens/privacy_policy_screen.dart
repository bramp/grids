import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// The bundled asset path for the privacy policy HTML.
const _privacyAsset = 'web/privacy.html';

/// On web, opens [/privacy.html] in a new tab.
/// On native platforms, pushes an in-app screen with the same content.
Future<void> showPrivacyPolicy(BuildContext context) async {
  if (kIsWeb) {
    await launchUrl(
      Uri.parse('privacy.html'),
      webOnlyWindowName: '_blank',
    );
  } else {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }
}

/// Renders the privacy policy HTML from [web/privacy.html] using
/// [HtmlWidget] from `flutter_widget_from_html_core`.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(_privacyAsset),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading policy: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: HtmlWidget(
                  snapshot.data!,
                  onTapUrl: (url) {
                    unawaited(launchUrl(Uri.parse(url)));
                    return true;
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
