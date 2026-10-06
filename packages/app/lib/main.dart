import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    name: 'dev',
    location: BannerLocation.bottomStart,
    variables: <String, dynamic>{
      'todo-api': 'https://api.server',
      'app-version': '0.0.0',
      'app-name': 'todo',
    },
  );
  await runMyApp();
}
