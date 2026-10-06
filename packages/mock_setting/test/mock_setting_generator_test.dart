import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mock_setting/src/mock_setting_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('MockSettingGenerator', () {
    late TestReaderWriter readerWriter;

    setUp(() async {
      readerWriter = TestReaderWriter(rootPackage: 'mock_setting');
      await readerWriter.testing.loadIsolateSources();
    });

    Builder createBuilder() => PartBuilder([
      MockSettingGenerator(resolveHost: () async => '192.168.0.10'),
    ], '.mock_setting.dart');

    test('replaces __ip_addr__ with the resolved host', () async {
      await testBuilder(
        createBuilder(),
        {
          'mock_setting|lib/example.dart': '''
import 'package:mock_setting/annotation.dart';

part 'example.mock_setting.dart';

@GenerateIpSetting('todo-api', 'http://__ip_addr__:4010')
void main() {}
''',
        },
        rootPackage: 'mock_setting',
        readerWriter: readerWriter,
        outputs: {
          'mock_setting|lib/example.mock_setting.dart': decodedMatches(
            contains(
              "final setting = <String, String>{'todo-api': "
              "'http://192.168.0.10:4010'};",
            ),
          ),
        },
      );
    });

    test('collects multiple annotations into one map', () async {
      await testBuilder(
        createBuilder(),
        {
          'mock_setting|lib/example.dart': '''
import 'package:mock_setting/annotation.dart';

part 'example.mock_setting.dart';

@GenerateIpSetting('todo-api', 'http://__ip_addr__:4010')
@GenerateIpSetting('static-api', 'https://api.example.com')
void main() {}
''',
        },
        rootPackage: 'mock_setting',
        readerWriter: readerWriter,
        outputs: {
          'mock_setting|lib/example.mock_setting.dart': decodedMatches(
            allOf(
              contains("'todo-api': 'http://192.168.0.10:4010'"),
              contains("'static-api': 'https://api.example.com'"),
            ),
          ),
        },
      );
    });
  });
}
