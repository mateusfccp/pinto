import 'element.dart';
import 'package.dart';

sealed class Type {
  Element? get element;
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
  String toString() => 'TopType';
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
  int get hashCode => Object.hash(
        name,
        source,
        arguments,
      );

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

// TODO(mateusfccp): Generalize to records-like
final class UnitType implements Type {
  const UnitType();

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is UnitType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '()';
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

final class FunctionType implements Type {
  FunctionType({
    required this.returnType,
    this.element,
  });

  Type get parameterType => const UnitType(); // Dummy paramter type for now

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
