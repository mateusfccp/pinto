import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: generate_ast <output directory>');
    exit(64); // exit(usage)
  } else {
    final [outputDir] = args;

    _defineAst(
      outputDir,
      'Node',
      {
        'TypeVariation': [
          ('Token', 'name'),
          ('List<TypeVariationParameterNode>', 'parameters'),
        ],
        'TypeVariationParameter': [
          ('Token', 'type'),
          ('Token', 'name'),
        ],
      },
      ['token.dart'],
    );

    _defineAst(
      outputDir,
      'Statement',
      {
        'TypeDefinition': [
          ('Token', 'name'),
          ('List<Token>?', 'typeParameters'),
          ('List<TypeVariationNode>', 'variants'),
        ],
      },
      ['node.dart', 'token.dart'],
    );
  }
}

void _defineAst(
  String outputDir,
  String baseName,
  Map<String, List<(String, String)>> types, [
  List<String> imports = const [],
]) {
  final filename = ReCase(baseName).snakeCase;
  final path = '$outputDir/$filename.dart';
  final file = File(path);
  file.createSync(recursive: true);

  // Imports
  final importsString = imports.map((import) => "import '$import';").join('\n');

  // Base class
  final baseClassString = _generateClass(
    className: baseName,
    abstract: true,
    interface: true,
    content: '''
    R accept<R>(${baseName}Visitor<R> visitor);
    ''',
  );

  final visitorInterfaceString = _defineVisitor(baseName, types);

  // AST classes
  final astClassesString = StringBuffer();

  for (final MapEntry(:key, :value) in types.entries) {
    final className = '$key$baseName';
    astClassesString.writeln(
      _defineType(baseName, className, value),
    );
  }

  final fileContent = '''
      $importsString
      
      $baseClassString
      $visitorInterfaceString
      $astClassesString
  ''';

  final formatter = DartFormatter();
  final formattedString = formatter.format(fileContent);

  file.writeAsStringSync(formattedString);
}

String _defineType(String baseName, String className, List<(String, String)> fields) {
  final content = StringBuffer();

  // Constructor
  content.writeln('const $className(');

  for (final (_, fieldName) in fields) {
    content.writeln('this.$fieldName,');
  }

  content.writeln(');');

  // Class fields
  for (final (fieldType, fieldName) in fields) {
    content.writeln('final $fieldType $fieldName;');
  }

  // Accept method
  content.writeln('''
  @override
  R accept<R>(${baseName}Visitor<R> visitor) {
    return visitor.visit$className(this);
  }
  ''');

  return _generateClass(
    final_: true,
    className: className,
    content: content.toString(),
    implementsClass: baseName,
  );
}

String _defineVisitor(String baseName, Map<String, List<(String, String)>> types) {
  final methodsString = StringBuffer();
  for (final type in types.keys) {
    final typeName = '$type$baseName';
    methodsString.writeln('R visit$type$baseName($typeName ${baseName.toLowerCase()});');
  }

  return _generateClass(
    className: '${baseName}Visitor',
    abstract: true,
    interface: true,
    generics: ['R'],
    content: methodsString.toString(),
  );
}

String _generateClass({
  required String className,
  String content = '',
  bool final_ = false,
  bool abstract = false,
  bool interface = false,
  String? extendsClass,
  String? implementsClass,
  List<String>? generics,
}) {
  assert(final_ != abstract && final_ != interface);

  const classTemplate = '''
  {final} {abstract} {interface} class {className}{generics} {extends} {implements} {
    {content}
  }
  ''';

  return classTemplate
      .replaceAll('{final}', final_ ? 'final' : '')
      .replaceAll('{abstract}', abstract ? 'abstract' : '')
      .replaceAll('{interface}', interface ? 'interface' : '')
      .replaceAll('{className}', className)
      .replaceAll('{generics}', generics == null || generics.isEmpty ? '' : '<${generics.join(', ')}>')
      .replaceAll('{extends}', extendsClass == null ? '' : 'extends $extendsClass')
      .replaceAll('{implements}', implementsClass == null ? '' : 'implements $implementsClass')
      .replaceAll('{content}', content);
}
