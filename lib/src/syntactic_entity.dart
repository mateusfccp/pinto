import 'package:collection/collection.dart';

import 'ast/ast.dart';
import 'ast/visitors.dart';

/// A syntactic entity in a source.
///
/// It may be either a [Token] or a [AstNode].
///
/// Syntactic entities can be located within a source code by their [offset].
abstract interface class SyntacticEntity {
  /// The start position of the syntactic entity within the source code.
  int get offset;

  /// The number of chracters composing the syntactic entity.
  int get length;

  /// The position after the last character of the syntactic entity.
  int get end;
}

/// A list of syntactic entities that is treated as a syntactic entity itself.
final class SyntacticEntityList<T extends SyntacticEntity> extends DelegatingList<T> implements SyntacticEntity {
  const SyntacticEntityList(super.base);

  @override
  int get offset => this[0].offset;

  @override
  int get length => end - offset;

  @override
  int get end => this[length - 1].end;
}

/// A list of [AstNode]s that can be visited as if it were an [AstNode].
extension type AstNodeList(SyntacticEntityList<AstNode>? _inner) {
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    for (final entity in _inner ?? []) {
      entity.accept(visitor);
    }
  }
}
