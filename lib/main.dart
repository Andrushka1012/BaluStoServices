import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app/mobile/mobile_app.dart';
import 'app/web/web_app.dart';

void main() async {
  if (kIsWeb) {
    runApp(WebApp());
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    MobileApp.initKoin();
    runApp(MobileApp());
  }
}
