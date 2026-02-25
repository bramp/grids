// Dummy firebase_options.dart to allow the project to compile.
// Please overwrite this file by configuring your project with the CLI:
// `flutterfire configure`

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this project. '
      'Run `flutterfire configure` to generate the correct configuration.',
    );
  }
}
