import 'node.dart';
import 'program.dart';
import 'statement.dart';

abstract interface class AstVisitor<T> //
    implements
        NodeVisitor<T>,
        ProgramVisitor<T>,
        StatementVisitor<T> {}
