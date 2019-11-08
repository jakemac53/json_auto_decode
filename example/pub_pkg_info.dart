import 'package:http/http.dart';
import 'package:json_auto_decode/json_auto_decode.dart';

main() async {
  var protobufData = (await get('https://pub.dev/api/packages/protobuf')).body;
  var pkgInfo = jsonAutoDecode<PkgInfo>(protobufData);
  print('''
name: ${pkgInfo.name}
latest version: ${pkgInfo.latest.version}
description: ${pkgInfo.latest.pubspec.description}
All versions:
${pkgInfo.versions.reversed.map((v) => '- ${v.version}').join('\n')}
''');
}

class PkgInfo {
  final String name;
  final VersionInfo latest;
  final List<VersionInfo> versions;

  PkgInfo({
    this.name,
    this.latest,
    this.versions,
  });
}

class VersionInfo {
  final String archiveUrl;
  final Pubspec pubspec;
  final String version;

  VersionInfo({
    this.archiveUrl,
    this.pubspec,
    this.version,
  });
}

class Pubspec {
  final String version;
  final Map<String, dynamic> dependencies;
  final String author;
  final String description;
  final String homepage;
  final Map<String, String> environment;
  final String documentation;
  final Map<String, dynamic> dev_dependencies;

  Pubspec({
    this.version,
    this.dependencies,
    this.author,
    this.description,
    this.homepage,
    this.environment,
    this.documentation,
    this.dev_dependencies,
  });
}
