final class Type {
  const Type({
    required this.name,
    this.package,
    required this.parameters,
  });

  final String name;

  final String? package;

  final List<Type> parameters;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Type &&
        other.name == name &&
        other.package == package &&
        other.parameters == parameters;
  }

  @override
  int get hashCode => Object.hash(
        name,
        package,
        parameters,
      );

  @override
  String toString() => 'Type(String name, String package, List parameters)';
}
