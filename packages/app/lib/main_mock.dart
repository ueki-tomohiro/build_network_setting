import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:mock_setting/annotation.dart';

part 'main_mock.mock_setting.dart';

@GenerateIpSetting('todo-api', 'http://__ip_addr__:4010')
Future<void> main() async {
  FlavorConfig(
    name: 'dev',
    location: BannerLocation.bottomStart,
    variables: <String, dynamic>{
      ...setting,
      'app-version': '0.0.0',
      'app-name': 'todo',
    },
  );
  await runMyApp();
}
