import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrmenu/firebase_options_dev.dart';

import 'flavors.dart';

import 'init_app.dart';
import 'main.dart' as runner;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.dev;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initApp();
  await runner.main();
}
