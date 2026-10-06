import 'package:build/build.dart';

import 'package:mock_setting/src/mock_setting_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder mockSettingBuilder(BuilderOptions options) => PartBuilder(
  [MockSettingGenerator()],
  '.mock_setting.dart',
  options: options,
  allowSyntaxErrors: true,
);
