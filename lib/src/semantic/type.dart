import 'element.dart';
import 'package.dart';

sealed class PintoType {
  Element? get element;
}

final class TopType implements PintoType {
  const TopType();

  @override
  Element? get element => null;

  @override
  bool operator ==(Object other) => other is TopType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TopType';
}

final class PolymorphicType implements PintoType {
  PolymorphicType({
    required this.name,
    required this.source,
    required this.arguments,
  });

  final String name;

  final Package source;

  final List<PintoType> arguments;

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
  String toString() => 'PolymorphicType(name: $name, source: $source, arguments: $arguments)';
}

final class TypeParameterType implements PintoType {
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
  String toString() => 'TypeParameterType(name: $name)';
}

final class BottomType implements PintoType {
  const BottomType();

  @override
  Element? get element => null;

  @override
  bool operator ==(Object other) => other is BottomType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BottomType';
}
