import 'declaration.dart';
import 'element.dart';
import 'package.dart';

final class ImportElement extends DeclarationElement {
  ImportElement({required this.package});

  final Package package;

  T accept<T>(ElementVisitor visitor) => visitor.visitImportElement(this);
}
