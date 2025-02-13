import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

@pragma('vm:prefer-inline')
/// Returns a [TypeReference] to [symbol] with type parameter `R`.
TypeReference referWithR(String symbol) {
  return TypeReference((builder) {
    builder.symbol = symbol;
    builder.types.add(refer('R'));
  });
}

extension FieldElementExtension on FieldElement {
  bool get isIterableOfNullable {
    if (type.isIterable) {
      final iterableType = type as InterfaceType;
      final typeArguments = iterableType.typeArguments;

      assert(
        typeArguments.length == 1,
        'Expected one type argument, found ${typeArguments.length}.',
      );

      return typeArguments.single.isNullable;
    }

    return false;
  }

    bool get isIterableOfVisitable {
    if (type.isIterable) {
      final iterableType = type as InterfaceType;
      final typeArguments = iterableType.typeArguments;

      assert(
        typeArguments.length == 1,
        'Expected one type argument, found ${typeArguments.length}.',
      );

      final typeArgument = typeArguments.single;

      if (typeArgument.element case InterfaceElement interfaceElement) {
        return interfaceElement.isVisitable;
      }
    }

    return false;
  }

  bool get isNullable => type.isNullable;
    
  bool get isVisitable {
    if (type.element case final InterfaceElement element) {
      return element.isVisitable;
    } else {
      return false;
    }
  }
}

extension InterfaceElementExtension on InterfaceElement {
  void descend(void Function(Element element) visitor) {
    visitor(this);

    for (final element in nodes) {
      element.descend(visitor);
    }
  }
  
  /// Whether this class is a leaf node in the AST tree.
  bool get isLeaf {
    final classesInLibrary = library.units.expand((unit) => unit.classes);

    for (final interface in classesInLibrary) {
      if (interface.allSupertypes.any((type) => type.element == this)) {
        return false;
      }
    }

    return true;
  }

  bool get isNode {
    return nodeAnnotation != null;
  }

  /// Whether this class is the root of AST tree.
  bool get isRoot => root == this;

  /// Whether this class is a visitable node.
  bool get isVisitable {
    final nodeAnnotation = metadata.firstWhereOrNull(
      (element) => element.element?.enclosingElement3?.name == 'TreeNode',
    );

    if (nodeAnnotation != null) {
      final computedValue = nodeAnnotation.computeConstantValue();
      final reader = ConstantReader(computedValue);
      return reader.read('visitable').boolValue;
    } else {
      return false;
    }
  }

  ElementAnnotation? get nodeAnnotation {
    return metadata.firstWhereOrNull(
      (element) => element.element?.enclosingElement3?.name == 'TreeNode',
    );
  }

  List<InterfaceElement> get nodes {
    final classesInLibrary = library.units.expand((unit) => unit.classes);

    return [
      for (final interface in classesInLibrary)
        if (interface.nodeAnnotation != null && interface.supertype?.element == this) interface,
    ];
  }

  InterfaceElement? get parent {
    if (supertype case final supertype?) {
      final metadata = supertype.element.metadata;

      for (final metadatum in metadata) {
        if (metadatum.element?.enclosingElement3?.name == 'TreeNode') {
          return supertype.element;
        }
      }
    }

    return null;
  }

  /// Returns the private name of the class.
  String get privateName => '_$name';

  /// Returns the root of the AST tree.
  InterfaceElement get root {
    var current = this;

    // TODO(mateusfccp): use while patterns when available.
    while (true) {
      if (current.parent case final InterfaceElement parent) {
        current = parent;
      } else {
        break;
      }
    }

    return current;
  }
}

extension on DartType {
  bool get isIterable {
    // First check for `Iterable` and its subtypes from `dart:core`.
    if (isDartCoreList || isDartCoreIterable || isDartCoreSet) {
      return true;
    }

    // Now check if the type is a subtype of any of the above types.
    if (element is InterfaceType) {
      final interface = element as InterfaceType;

      for (final type in interface.allSupertypes) {
        if (type.isIterable) {
          return true;
        }
      }
    }

    return false;
  }

  bool get isNullable {
    final typeSystem = element?.library?.typeSystem;

    if (typeSystem == null) {
      return false;
    } else {
      return typeSystem.isNullable(this);
    }
  }
}
