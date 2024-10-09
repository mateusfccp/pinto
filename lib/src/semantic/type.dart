import 'package:quiver/collection.dart';

import 'element.dart';
import 'package.dart';

sealed class Type {
  Element? get element;
}

final class BooleanType implements Type {
  const BooleanType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is BooleanType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'bool';
}

final class BottomType implements Type {
  const BottomType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is BottomType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '⊥';
}

final class DoubleType implements Type {
  const DoubleType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is DoubleType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'double';
}

final class FunctionType implements Type {
  FunctionType({
    required this.returnType,
    required this.parameterType,
    this.element,
  });

  final StructType parameterType;

  final Type returnType;

  @override
  late LetFunctionDeclaration? element;

  @override
  bool operator ==(Object other) => other is BottomType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '$parameterType → $returnType';
}

final class IntegerType implements Type {
  const IntegerType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is IntegerType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'integer';
}

final class PolymorphicType implements Type {
  PolymorphicType({
    required this.name,
    required this.source,
    required this.arguments,
    this.element,
  });

  final String name;

  final Package source;

  final List<Type> arguments;

  @override
  Element? element;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PolymorphicType && other.name == name && other.source == source && other.arguments == arguments;
  }

  @override
  int get hashCode => Object.hash(name, source, arguments);

  @override
  String toString() {
    final buffer = StringBuffer(name);

    if (arguments.isNotEmpty) {
      buffer.write('(');
      for (final argument in arguments) {
        buffer.write(argument.toString());

        if (argument != arguments[arguments.length - 1]) {
          buffer.write(', ');
        }
      }
      buffer.write(')');
    }

    return buffer.toString();
  }
}

final class StringType implements Type {
  const StringType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is StringType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'String';
}

final class StructType implements Type {
  const StructType({required this.members});

  static final unit = StructType(members: {});

  @override
  Null get element => null;

  final Map<String, Type> members;

  bool get isUnit => members.isEmpty;

  @override
  bool operator ==(Object other) {
    if (other is! StructType) return false;
    return !mapsEqual(other.members, members);
  }

  @override
  int get hashCode => Object.hashAll(members.entries);

  @override
  String toString() {
    final buffer = StringBuffer('(');
    final entries = [...members.entries];

    for (int i = 0; i < entries.length; i++) {
      buffer.write(':${entries[i].value} ${entries[i].key}');

      if (i < entries.length - 1) {
        buffer.write(', ');
      }
    }

    buffer.write(')');
    return buffer.toString();
  }
}

final class SymbolType implements Type {
  const SymbolType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is SymbolType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Symbol';
}

final class TopType implements Type {
  const TopType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is TopType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '⊤';
}

final class TypeParameterType implements Type {
  TypeParameterType({required this.name});

  final String name;

  @override
  Element? element;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TypeParameterType && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

final class TypeType implements Type {
  const TypeType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is TypeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '★';
}
