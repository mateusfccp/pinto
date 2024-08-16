sealed class Package {}

final class DartSdkPackage implements Package {
  const DartSdkPackage({required this.name});

  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DartSdkPackage && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'DartSdkPackage(name: $name)';
}

final class ExternalPackage implements Package {
  const ExternalPackage({required this.name});

  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExternalPackage && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'ExternalPackage(name: $name)';
}

sealed class Type {}

final class TopType implements Type {
  const TopType();

  @override
  bool operator ==(Object other) => other is TopType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TopType';
}

final class MonomorphicType implements Type {
  const MonomorphicType({
    required this.name,
    required this.source,
  });

  final String name;

  final Package source;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonomorphicType && other.name == name && other.source == source;
  }

  @override
  int get hashCode => Object.hash(
        name,
        source,
      );

  @override
  String toString() => 'MonomorphicType(name: $name, source: $source)';
}

final class PolymorphicType implements Type {
  const PolymorphicType({
    required this.name,
    required this.source,
    required this.arguments,
  });

  final String name;

  final Package source;

  final List<Type> arguments;

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

final class TypeParameterType implements Type {
  const TypeParameterType({required this.name});

  final String name;

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

final class BottomType implements Type {
  const BottomType();

  @override
  bool operator ==(Object other) => other is BottomType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BottomType';
}
