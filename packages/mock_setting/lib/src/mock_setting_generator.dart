import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:mock_setting/annotation.dart';
import 'package:source_gen/source_gen.dart'
    show ConstantReader, GeneratorForAnnotation;

typedef HostResolver = Future<String> Function();

class MockSettingGenerator extends GeneratorForAnnotation<GenerateIpSetting> {
  static const _replaceIp = '__ip_addr__';

  final HostResolver _resolveHost;

  MockSettingGenerator({HostResolver? resolveHost})
    : _resolveHost = resolveHost ?? _resolveLocalHost;

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final setting = <String, String>{};
    for (final annotation in element.metadata.annotations) {
      if (annotation.element is! ConstructorElement) continue;
      if (annotation.element?.enclosingElement?.name == 'GenerateIpSetting') {
        final entry = _entryFromGenerateIpSetting(annotation);
        setting[entry.key] = entry.value;
      }
    }

    final host = await _resolveHost();

    final settingCodes = <Code>[];
    settingCodes.addAll(_createCode(host, setting));

    final settingsLibrary = Library((b) => b..body.addAll([...settingCodes]));
    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final content =
        DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
            .format('''
${settingsLibrary.accept(emitter)}
''');
    return content;
  }

  static Future<String> _resolveLocalHost() async {
    if (!Platform.isMacOS) return 'localhost';

    var host = '';
    final ifconfig = await Process.start('ifconfig', ['-l']);
    final xargs = await Process.start('xargs', [
      '-n1',
      'ipconfig',
      'getifaddr',
    ]);
    await ifconfig.stdout.pipe(xargs.stdin);
    final sed = await Process.start('sed', ['-n', '-e', '1p']);
    await xargs.stdout.pipe(sed.stdin);

    await sed.stdout.transform(utf8.decoder).forEach((element) {
      host = element.trimRight();
    });
    return host;
  }

  List<Code> _createCode(String host, Map<String, String> settings) {
    final List<Code> codes = [Code('final setting = <String, String>{')];
    settings.forEach((key, value) {
      final ip = value.replaceAll(_replaceIp, host);
      codes.add(Code('\'$key\': \'$ip\','));
    });
    codes.add(Code('};'));

    return codes;
  }

  MapEntry<String, String> _entryFromGenerateIpSetting(
    ElementAnnotation annotation,
  ) {
    final settingValue = annotation.computeConstantValue()!;
    final nameField = settingValue.getField('name')!;
    final valueField = settingValue.getField('value')!;

    if (nameField.isNull) {
      throw ArgumentError('The GenerateIpSetting "name" argument is missing ');
    }

    if (valueField.isNull) {
      throw ArgumentError('The GenerateIpSetting "value" argument is missing ');
    }

    return MapEntry(nameField.toStringValue()!, valueField.toStringValue()!);
  }
}
