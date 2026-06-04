import 'dart:io';

void main() async {
  final pubCache = Platform.environment['PUB_CACHE'] ??
      '${Platform.environment[Platform.isWindows ? 'APPDATA' : 'HOME']}/${Platform.isWindows ? 'Pub/Cache' : '.pub-cache'}';

  final hostedDir = Directory('$pubCache/hosted/pub.dev');
  if (!hostedDir.existsSync()) {
    stderr.writeln('Error: pub cache not found at ${hostedDir.path}');
    exit(1);
  }

  final hugeIconsDir = hostedDir
      .listSync()
      .whereType<Directory>()
      .where((d) => d.path.split(Platform.pathSeparator).last.startsWith('hugeicons-'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (hugeIconsDir.isEmpty) {
    stderr.writeln('Error: hugeicons package not found in pub cache. Run flutter pub get first.');
    exit(1);
  }

  final packageDir = hugeIconsDir.last;
  final hugeIconsFile = File('${packageDir.path}/lib/hugeicons.dart');

  if (!hugeIconsFile.existsSync()) {
    stderr.writeln('Error: hugeicons.dart not found at ${hugeIconsFile.path}');
    exit(1);
  }

  print('Using: ${hugeIconsFile.path}');

  final lines = await hugeIconsFile.readAsLines();
  final iconNames = <String>[];

  for (final line in lines) {
    final match = RegExp(r'static const List<List<dynamic>> (\w+) =').firstMatch(line);
    if (match != null) {
      iconNames.add(match.group(1)!);
    }
  }

  final buffer = StringBuffer()
    ..writeln('// AUTO-GENERATED - run: dart scripts/generate_icon_map.dart')
    ..writeln('import \'package:hugeicons/hugeicons.dart\';')
    ..writeln()
    ..writeln('const Map<String, List<List<dynamic>>> hugeIconsMap = {');

  for (final name in iconNames) {
    buffer.writeln("  '$name': HugeIcons.$name,");
  }

  buffer
    ..writeln('};')
    ..writeln()
    ..writeln('List<List<dynamic>>? getHugeIconByName(String? name) => name == null ? null : hugeIconsMap[name];');

  final outputFile = File('lib/utils/huge_icons_map.dart');
  await outputFile.writeAsString(buffer.toString());

  print('Generated ${outputFile.path} with ${iconNames.length} icons.');
}
