import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox('products');
  await Hive.openBox('purchases');
  await Hive.openBox('settings');

  runApp(
    const ProviderScope(
      child: PrixCoursesApp(),
    ),
  );
}
