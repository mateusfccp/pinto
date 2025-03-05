import 'package:quiver/collection.dart';

import 'element.dart';

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
    required this.arguments,
    this.element,
  });

  final String name;

  final List<Type> arguments;

  bool get option {
    return name == 'Option';
  }

  @override
  Element? element;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PolymorphicType && other.name == name && other.arguments == arguments;
  }

  @override
  int get hashCode => Object.hash(name, arguments);

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

  StructType.singleton(Type member) : members = {r'$0': member};

  static const unit = StructType(members: {});

  @override
  Null get element => null;

  final Map<String, Type> members;

  bool get isUnit => members.isEmpty;

  @override
  bool operator ==(Object other) {
    if (other is! StructType) return false;
    return mapsEqual(other.members, members);
  }

  @override
  int get hashCode => Object.hashAll(members.entries);

  @override
  String toString() {
    final buffer = StringBuffer('(');
    final entries = [...members.entries];

    for (int i = 0; i < entries.length; i++) {
      buffer.write(':${entries[i].key} ${entries[i].value}');

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
  const TypeType(Type reference) : _reference = reference;

  const TypeType.self() : _reference = null;

  /// The type that this type represents.
  ///
  /// This is `null` if this type represents the type of a type (★).
  Type get reference => _reference ?? this;

  final Type? _reference;

  /// Whether this type represents the type of a type (★).
  bool get self => _reference == null;

  @override
  Null get element => null;

  @override
  bool operator ==(Object other) => other is TypeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '★';
}

extension SubtypeExtension on Type {
  /// Whether [this] is a subtype of [other].
  ///
  /// Currently, this is only valid for the top and bottom types. For all other
  /// types, this method will return `true` if [this] is equal to [other].
  ///
  /// Singleton structs types are considered the same as their member type.
  bool subtypeOf(Type other) {
    Type flattened(Type type) {
      if (type is StructType && type.members.length == 1) {
        return flattened(type.members.values.single);
      } else {
        return type;
      }
    }

    final self = flattened(this);
    other = flattened(other);

    return switch ((self, other)) {
      (BottomType(), _) || (_, TopType())  => true,
      _ => self == other,
    };
  }

  /// Whether [this] is a subtype of [other].
  ///
  /// This is the same as [subtypeOf].
  operator <(Type other) => subtypeOf(other);
}

/// Maps a parameter type to the expected argument type.
///
/// For instance, consider this function:
///
/// ```
/// let printMessage (:message String) = message
/// ```
///
/// `printMessage` parameter has a type (:message ★), but whe calling it, we
/// must pass a type (:message String).
StructType parameterTypeToExpectedArgumentType(StructType parameterType) {
  assert(
    parameterType.members.values.every((element) => element is TypeType),
    'All members of a parameter must be a type. Got ${parameterType.members.values} instead.',
  );

  final castedMembers = parameterType.members.cast<String, TypeType>();

  return StructType(
    members: {
      for (final entry in castedMembers.entries) entry.key: entry.value.reference,
    },
  );
}
