import 'dart:collection';

final class Node<T> {
  Node({
    required this.value,
    List<Node<T>>? children,
  }) : children = {for (final child in children ?? []) child.value: child} {
    for (final child in this.children.values) {
      child.parent = this;
    }
  }

  final T value;
  final Map<T, Node<T>> children;
  Node<T>? parent;

  Node<T> get root {
    if (parent case final parent?) {
      return parent.root;
    } else {
      return this;
    }
  }

  bool get leaf => children.isEmpty;

  void descent<U>(
    void Function(Node<T> node) executor,
  ) {
    executor(this);

    for (final child in children.values) {
      child.descent(executor);
    }
  }

  void bredthFirstDescent<U>(
    void Function(Node<T> node) executor,
  ) {
    final queue = Queue<Node<T>>();
    var current = this;

    queue.add(current);

    while (queue.isNotEmpty) {
      current = queue.removeFirst();
      executor(current);

      for (final child in current.children.values) {
        queue.add(child);
      }
    }
  }

  void ensureExists(List<T> keys) {
    if (keys.isNotEmpty) {
      final key = keys[0];
      final tail = keys.sublist(1);

      if (children[key] case final node?) {
        node.ensureExists(tail);
      } else {
        final node = Node<T>(value: key);
        node.ensureExists(tail);
        children[key] = node;
      }
    }
  }

  String describe([String padding = '']) {
    final buffer = StringBuffer();

    if (children.isEmpty) {
      buffer.write(value);
    } else {
      buffer.writeln('$value (');

      padding = '  $padding';

      for (final MapEntry(:key, :value) in children.entries) {
        buffer.writeln('$padding$key: ${value.describe(padding)}');
      }

      padding = padding.substring(2);
      buffer.write('$padding)');
    }
    return buffer.toString();
  }
}
