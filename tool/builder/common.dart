import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

TypeReference referWithR(String symbol) {
  return TypeReference((builder) {
    builder.symbol = symbol;
    builder.types.add(refer('R'));
  });
}

extension FieldElementExtension on FieldElement {
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

extension DartTypeExtension on DartType {
  bool get isIterable {
    // For now this is a simple check. We may need to improve it later.
    return isDartCoreList || isDartCoreIterable || isDartCoreSet;
  }

  bool get isNullable {
    return element!.library!.typeSystem.isNullable(this);
  }
}
