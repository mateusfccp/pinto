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

final class CurrentPackage implements Package {
  const CurrentPackage();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrentPackage;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'CurrentPackage';
}
