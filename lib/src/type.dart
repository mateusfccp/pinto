// final class Type {
//   const Type({
//     required this.name,
//     this.package,
//     required this.parameters,
//   });

//   final String name;

//   final String? package;

//   final List<Type> parameters;

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is Type &&
//         other.name == name &&
//         other.package == package &&
//         other.parameters == parameters;
//   }

//   @override
//   int get hashCode => Object.hash(
//         name,
//         package,
//         parameters,
//       );

//   @override
//   String toString() => 'Type(String name, String package, List parameters)';
// }

sealed class TypeSource {}

final class DartCore implements TypeSource {
  const DartCore({required this.name});

  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DartCore && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'DartCore(name: $name)';
}

final class Package implements TypeSource {
  const Package({required this.name});

  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Package && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Package(name: $name)';
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

  final TypeSource source;

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

  final TypeSource source;

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
