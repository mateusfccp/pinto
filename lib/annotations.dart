import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
final class TreeNode {
  const TreeNode({this.visitable = true});

  final bool visitable;
}
