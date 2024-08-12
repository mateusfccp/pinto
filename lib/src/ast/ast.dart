import 'node.dart';
import 'program.dart';
import 'statement.dart';
import 'type_literal.dart';

abstract interface class AstVisitor<T> //
    implements
        NodeVisitor<T>,
        ProgramVisitor<T>,
        StatementVisitor<T>,
        TypeLiteralVisitor<T> {}
