import 'token.dart';
import 'statement.dart';

typedef TypeDeclarationContext = ({
  Token typeName,
  List<Token> typeParameters,
  int definitionsCount,
});

final class Transpiler implements StatementVisitor<void> {
  Transpiler(this.sink);

  final StringSink sink;

  TypeStatement? _typeDeclarationContext;

  @override
  void visitTypeDefinitionStatement(TypeDefinitionStatement statement) {
    assert(_typeDeclarationContext != null);

    final context = _typeDeclarationContext!;

    final typesUsedInTheDefinition = [
      for (final parameter in statement.parameters) parameter.$1,
    ];

    final shouldStreamline = context.definitions.length == 1;

    final typeParameters = <Token>[];

    final implements = shouldStreamline ? null : context.name.lexeme;
    final implementingTypeParameters = <Token>[];

    if (_typeDeclarationContext?.typeParameters case final typeDeclarationContextTypeParameters?) {
      for (final parameter in typeDeclarationContextTypeParameters) {
        final has = typesUsedInTheDefinition.any((p) => p.type == TokenType.identifier && p.lexeme == parameter.lexeme);
        if (has) {
          typeParameters.add(parameter);
          implementingTypeParameters.add(parameter);
        } else {
          implementingTypeParameters.add(
            Token(
              // TODO(mateusfccp): Fix by not using tokens here
              type: TokenType.identifier,
              column: 0,
              line: 0,
              lexeme: 'Never',
            ),
          );
        }
      }
    }

    _writeDataClass(
      sink,
      name: statement.name.lexeme,
      typeParameters: typeParameters,
      implements: implements,
      implementingTypeParameters: implementingTypeParameters,
      fields: statement.parameters,
    );
  }

  @override
  void visitTypeStatement(TypeStatement statement) {
    _typeDeclarationContext = statement;

    if (statement.definitions case [final definition]) {
      definition.accept(this);
    } else {
      sink.write('sealed class ${statement.name.lexeme}');

      final typeParameters = statement.typeParameters;

      if (typeParameters != null) {
        _writeTypeParameters(
          sink,
          typeParameters: typeParameters,
        );
      }

      sink.writeln(' {}');

      for (final definition in statement.definitions) {
        definition.accept(this);
      }
    }

    sink.writeln();

    _typeDeclarationContext = null;
  }
}

void _writeConstructor(
  StringSink sink, {
  required String name,
  required List<(Token, Token)>? parameters,
  required bool isConst,
}) {
  if (isConst) {
    sink.write('const ');
  }

  sink.write('$name(');

  if (parameters != null && parameters.isNotEmpty) {
    sink.writeln('{');

    for (final (_, name) in parameters) {
      sink.writeln('required this.${name.lexeme},');
    }

    sink.write('}');
  }

  sink.writeln(');');
}

void _writeFields(
  StringSink sink, {
  required List<(Token, Token)> fields,
}) {
  for (final (type, name) in fields) {
    sink.writeln('final ${type.lexeme} ${name.lexeme};');
  }
}

void _writeEquals(
  StringSink sink, {
  required String className,
  required List<(Token, Token)>? fields,
  required List<Token>? typeParameters,
}) {
  sink.writeln('@override');
  sink.write('bool operator==(Object other)');

  if (fields == null || fields.isEmpty) {
    sink.write(' => other is $className');

    if (typeParameters != null) {
      _writeTypeParameters(
        sink,
        typeParameters: typeParameters,
      );
    }

    sink.writeln(';');
  } else {
    sink.writeln(' {');
    sink.writeln('if (identical(this, other)) return true;');
    sink.writeln();
    sink.write('return other is $className');

    if (typeParameters != null) {
      _writeTypeParameters(
        sink,
        typeParameters: typeParameters,
      );
    }

    sink.writeln(' &&');
    // TODO(mateusfccp): Maybe turn this into a parameter
    // sink.writeln('other.runtimeType == runtimeType &&');

    for (final (_, name) in fields) {
      sink.write('other.${name.lexeme} == ${name.lexeme}');

      if (fields[fields.length - 1].$2 != name) {
        sink.writeln(' &&');
      }
    }

    sink.writeln(';');
    sink.writeln('}');
  }
}

void _writeHashcode(
  StringSink sink, {
  required List<(Token, Token)>? fields,
}) {
  sink.writeln('@override');
  sink.write('int get hashCode => ');

  if (fields == null || fields.isEmpty) {
    sink.writeln('runtimeType.hashCode');
  } else if (fields case [(_, final name)]) {
    sink.write('${name.lexeme}.hashCode');
  } else {
    if (fields.length <= 20) {
      sink.write('Object.hash(');
    } else {
      sink.write('Object.hashAll([');
    }

    for (final (_, name) in fields) {
      sink.write(name.lexeme);

      if (fields[fields.length - 1].$2 != name) {
        sink.write(',');
      }
    }

    if (fields.length <= 20) {
      sink.write(')');
    } else {
      sink.write('])');
    }
  }

  sink.writeln(';');
}

void _writeTypeParameters(
  StringSink sink, {
  required List<Token> typeParameters,
}) {
  if (typeParameters.isEmpty) return;

  sink.write('<');

  for (int i = 0; i < typeParameters.length; i++) {
    sink.write(typeParameters[i].lexeme);

    if (i != typeParameters.length - 1) {
      sink.write(', ');
    }
  }

  sink.write('>');
}

void _writeDataClass(
  StringSink sink, {
  required String name,
  List<Token>? typeParameters,
  String? implements,
  List<Token>? implementingTypeParameters,
  List<(Token, Token)>? fields,
}) {
  sink.write('final class $name');

  if (typeParameters != null) {
    _writeTypeParameters(
      sink,
      typeParameters: typeParameters,
    );
  }

  if (implements != null) {
    sink.write(' implements $implements');

    if (implementingTypeParameters != null) {
      _writeTypeParameters(
        sink,
        typeParameters: implementingTypeParameters,
      );
    }
  }

  sink.writeln(' {');

  _writeConstructor(
    sink,
    isConst: true,
    name: name,
    parameters: fields,
  );

  if (fields != null) {
    sink.writeln();

    _writeFields(
      sink,
      fields: fields,
    );

    sink.writeln();

    _writeEquals(
      sink,
      className: name,
      fields: fields,
      typeParameters: typeParameters,
    );

    sink.writeln();

    _writeHashcode(
      sink,
      fields: fields,
    );
  }

  sink.writeln('}');
}
