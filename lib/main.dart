import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap/bootstrap.dart';
import 'app/bootstrap/bootstrap_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bootstrapData = await bootstrapApplication();

  runApp(
    ProviderScope(
      overrides: [bootstrapDataProvider.overrideWithValue(bootstrapData)],
      child: const OkkQcApp(),
    ),
  );
}
